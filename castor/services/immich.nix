{ pkgs, ... }:
{
  # enable service
  services.immich.enable = true;
  services.immich.port = 2283;
  
  # open firewall to all on network
  services.immich.host = "0.0.0.0";
  services.immich.openFirewall = true;
  
  # reduce logs
  services.immich.environment.IMMICH_LOG_LEVEL = "warn";

  # change media location
  services.immich.mediaLocation = "/data/immich";

  # disable ML (not enough memory)
  services.immich.machine-learning.enable = false;

  # hardware accellerated video transcoding
  # `null` will give access to all devices.
  services.immich.accelerationDevices = null;
  boot.kernelParams = [ "vc4-kms-v3d" ];
  # hardware.raspberry-pi."4".fkms-3d.enable = false;
  # hardware.raspberry-pi."4".kms-3d.enable = true;
  hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
        libva
        v4l-utils
    ];
  };
  users.users.immich.extraGroups = [ "video" "render" ];

}