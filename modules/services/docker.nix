{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "tim" ];
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}