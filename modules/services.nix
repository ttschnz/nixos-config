{ config, pkgs, ... }:

{
  # Fuse filesystem that returns symlinks to executables based on the PATH of the requesting process.
  # This is useful to execute shebangs on NixOS that assume hard coded locations in locations like /bin or /usr/bin etc.
  services.envfs.enable = true;  

  # Enable the X11 windowing system.
  services.xserver.enable = true; 

  # Podman, a daemonless container engine for developing, 
  # managing, and running OCI Containers on your Linux System.
  virtualisation.podman.enable = true;

  # printd daemon and PAM module for fingerprint readers handling.
  services.fprintd.enable = true;

  # enable team viewer
  services.teamviewer.enable = true;

  # enable globalprotect VPN 
  # services.globalprotect.enable = true; # CVE-2025-6558 

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";  

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # fido auth
  security.pam.services.gdm.enableGnomeKeyring = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true; 
}