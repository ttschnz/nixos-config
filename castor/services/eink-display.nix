{ config, pkgs, ... }:

{
  systemd.services.eink-display = {
    description = "Serve index.html";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.python3}/bin/python3 -m http.server 19324 --bind 0.0.0.0 --directory /home/tim/temp";
      Restart = "on-failure";
      RestartSec = 5;
      User = "tim";
    };
  };

  networking.firewall.allowedTCPPorts = [ 19324 ];
}