{ config, lib, pkgs, ... }:

let
  domain = "immich.srv03.ttschnz.ch";

  # Private link between host and NixOS container.
  hostIP = "10.231.0.1";
  containerIP = "10.231.0.2";

  listenPort = 18080;

  dataDirHost = "/data/services/immich-public";
  dataDirContainer = "/srv/immich-public";

  publicProxyTailnetIP = "100.103.212.96";
in
{
  # Ensure the host-side storage directory exists before the container starts.
  systemd.tmpfiles.rules = [
    "d ${dataDirHost} 0755 root root - -"
  ];

  containers.immich-public = {
    autoStart = true;

    # Gives the container a separate network namespace.
    privateNetwork = true;
    hostAddress = hostIP;
    localAddress = containerIP;

    # Persist all relevant Immich data on your ZFS pool.
    bindMounts.${dataDirContainer} = {
      hostPath = dataDirHost;
      mountPoint = dataDirContainer;
      isReadOnly = false;
    };

    forwardPorts = [
      {
        protocol = "tcp";
        hostPort = listenPort;
        containerPort = listenPort;
      }
    ];

    config = { config, lib, pkgs, ... }: {
      system.stateVersion = "26.05"; # Use your host's stateVersion if different.

      networking.firewall.allowedTCPPorts = [ listenPort ];

      # Usually safer for a temporary photo dump: no ML, less RAM/CPU, fewer moving parts.
      services.immich = {
        enable = true;
        host = "0.0.0.0";
        port = listenPort;

        # Keep uploaded media separate from DB/cache.
        mediaLocation = "${dataDirContainer}/media";

        machine-learning.enable = false;

        settings = {
          server.externalDomain = "https://${domain}";
          newVersionCheck.enabled = false;
        };
      };

      # Put the container's PostgreSQL data on /data as well, not on the SD/root FS.
      services.postgresql.dataDir = "${dataDirContainer}/postgresql";

      systemd.tmpfiles.rules = [
        "d ${dataDirContainer} 0755 root root - -"
        "d ${dataDirContainer}/media 0700 immich immich - -"
        "d ${dataDirContainer}/postgresql 0700 postgres postgres - -"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ listenPort ];

  networking.firewall.extraCommands = ''
    ${pkgs.iptables}/bin/iptables -I FORWARD 1 \
      -i tailscale0 \
      -d ${containerIP} \
      -p tcp \
      --dport ${toString listenPort} \
      -j ACCEPT
  '';

  networking.firewall.extraStopCommands = ''
    ${pkgs.iptables}/bin/iptables -D FORWARD \
      -i tailscale0 \
      -d ${containerIP} \
      -p tcp \
      --dport ${toString listenPort} \
      -j ACCEPT || true
  '';
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };
}