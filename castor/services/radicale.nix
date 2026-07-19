{ config, pkgs, ... }:

let 
  listenPort = 5232;
  service_folder = "/data/services/radicale";
  pwd_file  = "${service_folder}/htpasswd";
  fs_folder = "${service_folder}/collections";
 in
{
  networking.firewall.allowedTCPPorts = [ listenPort ];
  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [ "0.0.0.0:${toString listenPort}" "[::]:${toString listenPort}" ];
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = pwd_file;
        htpasswd_encryption = "bcrypt";
      };
      storage = {
        filesystem_folder = fs_folder;
      };
    };
  };
}