{ pkgs, ... }: with pkgs; [
  gnomeExtensions.dash-to-dock
  gnomeExtensions.vitals
  gnomeExtensions.gsconnect
  gnomeExtensions.battery-health-charging
  gnome-network-displays
  gnome-power-manager
  gnome-clocks
  gnome-boxes # VM management
]