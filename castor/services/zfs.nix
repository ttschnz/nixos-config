{ config, pkgs, ... }:

{
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "data" ];

  # false for HDDs, true for SSDs
  services.zfs.trim.enable = false;
  
  services.zfs.autoScrub = {
    enable = true;
    pools = [ "data" ];
  };

  # services.zfs.zed.enableMail = true;
  # services.zfs.zed.settings = {
  #   ZED_EMAIL_ADDR = [ config.sops.secrets."git/email".value; ];
  #   ZED_EMAIL_PROG = "${pkgs.mailutils}/bin/mail";
  #   ZED_EMAIL_OPTS = "-s '@SUBJECT@' @ADDRESS@";
  #   ZED_NOTIFY_INTERVAL_SECS = 3600;
  #   ZED_NOTIFY_VERBOSE = true;
  # };

  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 2;
    hourly = 4;
    daily = 7;
    weekly = 4;
    monthly = 3;
  };

  # disable suspending usb
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  
  systemd.services.zfs-dataset-properties = {
    description = "Set ZFS dataset properties for castor";
    wantedBy = [ "multi-user.target" ];
    after = [ "zfs-import.service" ];
    requires = [ "zfs-import.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    path = [ pkgs.zfs ];

    script = ''
      zfs list data/tim >/dev/null 2>&1 && \
        zfs set com.sun:auto-snapshot=true data/tim

      zfs list data/shared >/dev/null 2>&1 && \
        zfs set com.sun:auto-snapshot=true data/shared

      zfs list data/backup >/dev/null 2>&1 && \
        zfs set com.sun:auto-snapshot=false data/backup
    '';
  };
}