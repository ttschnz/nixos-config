{ config, pkgs, ... }:

{
  networking = {
    hostName = "ttschnz"; # Define your hostname.
    networkmanager.enable = true;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    
    # MediaTek WiFi 6 sometimes has intermittent stability issues.
    # Because "deauthenticating from ... by local choice (Reason: 3=DEAUTH_LEAVING)" appears in logs (sudo journalctl -k -b | grep wlp1s0)
    # Disabling powersave might help stabilizing connectivity.
    wifi.powersave = false; 
    # Reducing roaming aggressiveness prevents NetworkManager from constantly scanning for and switching to nearby APs, which might be part of the issue.
    wifi.scanRandMacAddress = false;

    firewall = {
      enable = true;
      allowedTCPPortRanges = [ { from = 1714; to = 1764;} ]; # for Gsconnect
      allowedUDPPortRanges = [ { from = 1714; to = 1764;} ]; # for Gsconnect
    };

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  security.pki.certificates = 
  [ ''
    T (me)
    =========
    -----BEGIN CERTIFICATE-----
MIIDJzCCAg+gAwIBAgIUbyLkOrnxA7oepQx+43FULFLk22owDQYJKoZIhvcNAQEL
BQAwPDELMAkGA1UEBhMCQ0gxDTALBgNVBAgMBEJlcm4xEDAOBgNVBAoMB1ByaXZh
dGUxDDAKBgNVBAMMA1RpbTAeFw0yNjAxMDkxMjUyMjVaFw0zNjAxMDcxMjUyMjVa
MDwxCzAJBgNVBAYTAkNIMQ0wCwYDVQQIDARCZXJuMRAwDgYDVQQKDAdQcml2YXRl
MQwwCgYDVQQDDANUaW0wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDj
tH/BwdilVuBMq0uK5NewD8LB3Q/R9XccXli7mdIkzi/y0VKrOjkzprfkZR4AtT4y
sy3LvhYZr0XklHChxRANrLqL7ICgbtdAJiXVNwxv/3wf9QUgocRTySzprLbUiFj4
ru5OVqSxngefpWdtpa0LQkkEyrFazKuzzJiCJBrlhRWRTiIlINeOV7s0lJp1y+5L
fDbQeZOgz3KP2D2CRKhWzgr9XXW3KRyLjMYAlV5QLqbwjx3jm96fgHKmpebFgFFl
Aiw3SZN8wYsbfov287Z7zM2ZMPATgRRsdU0yr/uZKydjTuwDH+RuPzuuKw7Ex6aq
UXLyeS/E2wOxMSbBCfepAgMBAAGjITAfMB0GA1UdDgQWBBRf6RU8HRiAtkPA+8Ci
SVH17e760TANBgkqhkiG9w0BAQsFAAOCAQEAr9skB/guH6LmfEMP339VDi9wTlCf
i0bog9+uv1zx2+eSkHA1N2QfsnB/x000djcZKTFU6w9cwx8BUPQ8CADa0cSOCAnK
aVVg78uxzcUHKH3KIOTezWai1kYT44mFd1bPiz7zcq7lzNBtdrQZe3KSmdn1ywOu
3IhO0H1T0HxeHA/MngHTkLhjNI+RP6jS3L066eyLo/yJfJ47+tI8Q1LbA+W9QrAO
VLJCWCgfzHva1C9Mrd7vi+rVQjbi2BFJx1zA9KW5sTmAtgwFRW/FoXfq8K13mYtR
mzRv+b6JWCRjCO4UfU+LiLR7tTp9XKraKtuGYYDmTffJ3L7B1MmV+oFjfA==
-----END CERTIFICATE-----
  ''
];
}
