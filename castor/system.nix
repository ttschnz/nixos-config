{ pkgs, lib, ... }:
{
  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  
  environment.systemPackages = with pkgs; [
    borgbackup
  ];

  # Raspberry Pi 4 firmware
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.raspberrypiWirelessFirmware ];
  hardware.bluetooth.enable = false;
  nixpkgs.hostPlatform = "aarch64-linux";

  # Bootloader
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  
  # Set your time zone.
  time.timeZone = "Europe/Zurich";
  
  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "sg";
  };

  # Quiet boot
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" "loglevel=0" ];

  # users are declarative only (security)
  users.mutableUsers = false;

  # Clean the Nix store every week.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  services.timesyncd.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?

}