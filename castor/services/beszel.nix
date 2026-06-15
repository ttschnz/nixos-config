{ ... }:

{
  services.beszel.hub = {
    enable = true;
    host = "0.0.0.0";
    port = 8090;
    dataDir = "/var/lib/beszel-hub";
  };

  # fileSystems."/var/lib/beszel-hub" = {
  #   fsType = "none";
  #   device = "/data/services/beszel";
  #   options = [ "bind" ];
  # };

  services.beszel.agent = {
    enable = true;
    openFirewall = true;
    smartmon.enable = true;
    environment = {
      SERVICE_PATTERNS="*service,*.timer";
      KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEB+YP80G57z79IluQRrD7C5868EddyLeZszItZ53cEA";
      EXTRA_FILESYSTEMS="/data__zfs_pool";
    };
  };
}