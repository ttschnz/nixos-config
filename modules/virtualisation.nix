{ config, pkgs, ... }:

{

  virtualisation.waydroid.enable = true;

  # Set up virtualisation
  virtualisation.libvirtd = {
      enable = true;
    };

  # Enable USB redirection
  virtualisation.spiceUSBRedirection.enable = true;
}