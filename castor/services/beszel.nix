{ ... }:

{
  services.beszel.hub = {
    enable = true;
    host = "0.0.0.0";
    port = 8090;
    dataDir = "/data/services/beszel";
  };

  services.beszel.agent = {
    enable = true;
    openFirewall = true;
    smartmon.enable = true;
  };
}