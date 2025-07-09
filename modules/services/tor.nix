{ config, pkgs, ... }:

{
  # enable tor: pipe all traffic through the tor network
  services.tor = {
    # enable = true;
    client = {
      # enable = true;
    };
    settings = {
      UseBridges = true;  # If you're not using bridges
      ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/lyrebird";  # Optional, if you're using bridges with obfs4
      Bridge = "obfs4 IP:ORPort [fingerprint]";
    };
  };
}