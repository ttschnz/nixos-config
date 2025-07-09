{ config, pkgs, ... }:

{
  users.users.tim = {
    isNormalUser = true;
    description = "Tim";
    extraGroups = [ "wheel" "networkmanager" "plugdev" "dialout" "scanner" "libvirtd" "kvm"];
    shell = pkgs.bash; # or pkgs.zsh
    openssh.authorizedKeys.keys = [
      config.sops.secrets."ssh/keys/id_ed25519_pub".value
      config.sops.secrets."ssh/keys/id_rsa_pub".value
    ];
  };
}
