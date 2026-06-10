{ config, pkgs, lib, ... }:

{
  # WiFi driver fixes for Pi 4
  # Change regulatory domain to your country: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom=CH
    options brcmfmac roamoff=1 feature_disable=0x82000
  '';

  # Networking
  networking.hostName = "castor";
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };
  networking.useDHCP = lib.mkDefault true;
  networking.hostId = "03bc902c"; # generated with: head -c4 /dev/urandom | od -A none -t x4

  # mDNS for raspberry.local
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish.enable = true;
    publish.addresses = true;
  };

  # Unblock WiFi at boot (common Pi issue)
  systemd.services.rfkill-unblock-wifi = {
    description = "Unblock WiFi";
    wantedBy = [ "multi-user.target" ];
    before = [ "NetworkManager.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock wifi";
      RemainAfterExit = true;
    };
  };
}