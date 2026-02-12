{ config, pkgs, lib, ... }:

{

  virtualisation.waydroid = {
    enable = true;
    # extraArgs = [
    #   "--system-property=ro.hardware.gralloc=default"
    #   "--system-property=ro.hardware.egl=swiftshader"
    #   "--system-property=ro.hardware.vulkan=swiftshader"
    # ];
  };
  # ensure consistent v4l2 device exposure to waydroid
  # => "allow camera access"
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  # services.udev.extraRules = lib.mkAfter ''
  #   SUBSYSTEM=="video4linux", KERNEL=="video*", GROUP="video", MODE="0666"
  #   # ignore internal cams when not 0. 1,3=metadata, 2=gray.
  #   SUBSYSTEM=="video4linux", ATTR{name}=="Integrated Camera: Integrated C", ATTR{index}=="1", RUN+="${pkgs.coreutils}/bin/rm -f /dev/%k"
  #   SUBSYSTEM=="video4linux", ATTR{name}=="Integrated Camera: Integrated I", ATTR{index}=="2", RUN+="${pkgs.coreutils}/bin/rm -f /dev/%k"
  #   SUBSYSTEM=="video4linux", ATTR{name}=="Integrated Camera: Integrated I", ATTR{index}=="3", RUN+="${pkgs.coreutils}/bin/rm -f /dev/%k"
  # '';

  # systemd.services.fix-camera-format = {
  #   description = "Force camera to MJPEG 640x480";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "dev-video0.device" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #       ExecStart = "${pkgs.v4l-utils}/bin/v4l2-ctl -d /dev/video0 --set-fmt-video=width=640,height=480,pixelformat=MJPG";
  #   };
  # };
  # boot.kernelModules = [ "v4l2loopback" ];

  # boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];

  # boot.extraModprobeConfig = ''
  #   options v4l2loopback devices=1 video_nr=1 card_label="WaydroidCam" exclusive_caps=1
  # '';
  # environment.systemPackages = [
  #   config.boot.kernelPackages.v4l2loopback
  # ];
  # Hide unwanted V4L2 nodes from Waydroid container
  systemd.services.waydroid-container = {
    serviceConfig = {
      # BindPaths = [
      #   "/dev/video0"
      # ];
      # InaccessiblePaths = [
      #   "/dev/video1"
      #   "/dev/video2"
      #   "/dev/video3"
      # ];
      #---
      # DeviceAllow = [
      #   "/dev/video0 rw"
      # ];
     
      # # First remove full /dev exposure
      # BindPaths = [
      #   "/dev/null"
      #   "/dev/zero"
      #   "/dev/random"
      #   "/dev/urandom"
      #   "/dev/dri"
      #   "/dev/video0"
      # ];

      # # Completely hide other video nodes
      # TemporaryFileSystem = "/dev:ro";
    };
  };

  # Set up virtualisation
  virtualisation.libvirtd = {
      enable = true;
    };

  # Enable USB redirection
  virtualisation.spiceUSBRedirection.enable = true;
}