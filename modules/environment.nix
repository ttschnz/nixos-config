{ config, pkgs, ... }:

{
  environment.shells = [pkgs.xonsh];

  # tell nautilus to use gstreamer from nixpkgs to display file properties and previews
  environment.variables = {
    GST_PLUGIN_PATH = "/run/current-system/sw/lib/gstreamer-1.0/";
  };
}