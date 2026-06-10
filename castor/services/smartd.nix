{ config, pkgs, ... }:

{
  services.smartd = {
    enable = true;
    # all monitoring, offline collection, shorttest daily, longtest weekly
    defaults.monitored = "-a -o on -s (S/../.././02|L/../../6/03)";
    # Add mail later once a local MTA or SMTP relay is configured.
    # notifications = {
    #   mail = {
    #     enable = true;
    #     recipient = config.sops.secrets."git/email".value;
    #   };
    # };
  };
}