{ ... }:
{
  services.tailscale = {
    enable = true;
    authKeyFile = "/home/tim/.ts_auth_key"; # expires after 7 days, rewrite
  };
}