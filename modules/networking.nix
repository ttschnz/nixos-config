{ config, pkgs, ... }:

{
  networking = {
    hostName = "ttschnz"; # Define your hostname.
    networkmanager.enable = true;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    
    firewall = {
      enable = true;
      allowedTCPPortRanges = [ { from = 1714; to = 1764;} ]; # for Gsconnect
      allowedUDPPortRanges = [ { from = 1714; to = 1764;} ]; # for Gsconnect
    };

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
}
