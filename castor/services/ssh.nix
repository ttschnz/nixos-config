{ pkgs, lib, ... }:

{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "no";
    };
  };
   systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
} 
