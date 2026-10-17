{ config, lib, pkgs, ... }:

# Serves every subfolder of ~/static-web whose name is a port number on that port.
#
#   ~/static-web/
#   ├── 19240/index.html   -> http://host:19240/
#   └── 29328/index.html   -> http://host:29328/
#
# Creating, deleting or renaming a top-level folder is picked up immediately
# (systemd path unit -> reconcile script). No rebuild needed.

let
  user = "tim";
  group = "users";
  directory = "/home/tim/static-web";
  portFrom = 19000;
  portTo = 29999;

  siteDir = "${directory}/%i";
in
{
  systemd.tmpfiles.rules = [
    "d ${directory} 0755 ${user} ${group} -"
  ];

  # Listening socket, owned by systemd. Plain port number = IPv4 + IPv6.
  systemd.sockets."static-web@" = {
    description = "Static web socket for ${siteDir}";
    unitConfig.ConditionPathIsDirectory = siteDir;
    listenStreams = [ "%i" ];
  };

  # The server, started on first request, sandboxed to its own folder.
  systemd.services."static-web@" = {
    description = "Static web server for ${siteDir}";
    bindsTo = [ "static-web@%i.socket" ];
    after = [ "static-web@%i.socket" ];
    unitConfig.ConditionPathIsDirectory = siteDir;

    serviceConfig = {
      ExecStart = lib.escapeShellArgs [
        (lib.getExe pkgs.static-web-server)
        "--fd" "0"                         # use the socket systemd passed in
        "--root" siteDir
        "--directory-listing" "false"
        "--ignore-hidden-files" "true"     # never serve .git, .env, ...
        "--disable-symlinks" "true"
        "--security-headers" "true"
        "--cache-control-headers" "true"
        "--log-level" "warn"
      ];
      User = user;
      Restart = "on-failure";
      RestartSec = 5;

      # Filesystem: empty /home, then only this site's folder, read-only.
      ProtectSystem = "strict";
      ProtectHome = "tmpfs";
      BindReadOnlyPaths = [ siteDir ];
      PrivateTmp = true;
      PrivateDevices = true;
      UMask = "0077";

      # Network: none. The listening socket is inherited from the .socket unit.
      PrivateNetwork = true;
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];

      # Privileges
      NoNewPrivileges = true;
      CapabilityBoundingSet = "";
      AmbientCapabilities = "";
      PrivateUsers = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;

      # Kernel / system
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProtectHostname = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];

      # Resource limits, so one site can't take the box down.
      MemoryMax = "256M";
      TasksMax = 64;
    };
  };

  # Reconciler: one socket per valid folder, nothing for removed ones.
  systemd.services.static-web-sync = {
    description = "Sync static-web@ instances with ${directory}";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ config.systemd.package pkgs.coreutils pkgs.gnugrep ];
    serviceConfig.Type = "oneshot";
    script = ''
      shopt -s nullglob
      declare -A want=()

      for d in ${lib.escapeShellArg directory}/*/; do
        name=$(basename "$d")
        if [[ $name =~ ^[1-9][0-9]{0,4}$ ]] && (( name >= ${toString portFrom} && name <= ${toString portTo} )); then
          want[$name]=1
        else
          echo "ignoring '$name': not a port number in ${toString portFrom}-${toString portTo}"
        fi
      done

      known=$(systemctl list-units --all --plain --no-legend 'static-web@*' \
        | grep -oE 'static-web@[0-9]+' | cut -d@ -f2 | sort -u || true)

      for port in $known; do
        if [[ -z "''${want[$port]:-}" ]]; then
          echo "stopping port $port (folder gone)"
          systemctl stop "static-web@$port.socket" "static-web@$port.service" || true
          systemctl reset-failed "static-web@$port.socket" "static-web@$port.service" 2>/dev/null || true
        fi
      done

      for port in "''${!want[@]}"; do
        systemctl reset-failed "static-web@$port.socket" "static-web@$port.service" 2>/dev/null || true
        systemctl start "static-web@$port.socket" || echo "failed to listen on port $port"
      done
    '';
  };

  # Re-run the reconciler whenever an entry in the directory is created/removed/renamed.
  systemd.paths.static-web-sync = {
    wantedBy = [ "multi-user.target" ];
    pathConfig.PathChanged = directory;
  };

  networking.firewall.allowedTCPPortRanges = [
    { from = portFrom; to = portTo; }
  ];
}