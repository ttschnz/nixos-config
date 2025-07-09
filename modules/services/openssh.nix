{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  #services.openssh.authorizedKeysInHomedir = true;
  services.openssh.settings.AllowUsers = ["tim"];  
}