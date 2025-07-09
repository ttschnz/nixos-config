# activate: sudo nixos-rebuild switch
# setup: ln -s ~/Nix/configuration.nix /etc/nixos/configuration.nix

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, libs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ch";
  };
  
  # Configure console keymap
  console.keyMap = "sg";


  

  # 2025-09-10: worked (6.12.?? -> 6.12.46)
  # 2025-09-15: worked (6.12.46 -> 6.12.47)
  # 2025-09-28: failed (6.12.47 -> 6.12.48, reverted to x.46)
  # 2025-10-24: failed (6.12.46 -> 6.12.54, reverted to x.46)
  boot.kernelParams = [ "mt7921_common.disable_clc=1" ]; # try fix boot kernel freeze https://github.com/NixOS/nixpkgs/issues/448088#issuecomment-3368447041

  # Bootloader
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      splashImage = pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader.gnomeFilePath;
      useOSProber = true;
    };
  };
  
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };

  boot.crashDump.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];
  
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
