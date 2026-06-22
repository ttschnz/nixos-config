{ pkgs, ... }:

let
  systemctl = "${pkgs.systemd}/bin/systemctl";
  tailscale = "${pkgs.tailscale}/bin/tailscale";
  jq = "${pkgs.jq}/bin/jq";

  watchdogFile = "/dev/watchdog";
  watchdogTimeoutSec = 15;
  feedIntervalSec = 5;
  startupGraceSec = 60;

  watchdogFeeder = pkgs.writeShellScript "watchdog-feeder" ''
    set -eu

    log() {
      echo "watchdog-feeder: $*" >&2
    }

    healthy() {
      if ! ${tailscale} status --json | ${jq} -e '.Self.Online == true' >/dev/null; then
        log "tailscale is not online"
        return 1
      fi

      state="$(${systemctl} is-system-running 2>/dev/null || true)"

      case "$state" in
        running|starting|initializing)
          return 0
          ;;
        *)
          log "systemd state is '$state'"
          return 1
          ;;
      esac
    }

    if [ ! -c "${watchdogFile}" ]; then
      log "${watchdogFile} is not a character device"
      exit 1
    fi

    # Allow boot/network/tailscale to settle before arming the watchdog.
    waited=0
    while [ "$waited" -lt ${toString startupGraceSec} ]; do
      if healthy; then
        break
      fi

      sleep ${toString feedIntervalSec}
      waited=$((waited + ${toString feedIntervalSec}))
    done

    # Opening the watchdog arms it.
    exec 3>"${watchdogFile}"

    if ! healthy; then
      log "system unhealthy after startup grace; watchdog will not be fed"
      exit 1
    fi

    while true; do
      if ! healthy; then
        log "system unhealthy; watchdog will not be fed"
        exit 1
      fi

      # Any byte except the magic-close byte is a keepalive ping.
      printf '\0' >&3

      sleep ${toString feedIntervalSec}
    done
  '';
in
{
  boot.kernelModules = [ "bcm2835_wdt" ];

  # For bcm2835_wdt as a module.
  boot.extraModprobeConfig = ''
    options bcm2835_wdt heartbeat=${toString watchdogTimeoutSec} nowayout=1
  '';

  # For bcm2835_wdt if built into the kernel.
  boot.kernelParams = [
    "bcm2835_wdt.heartbeat=${toString watchdogTimeoutSec}"
    "bcm2835_wdt.nowayout=1"
  ];

  # Do not let PID 1 also own/feed the hardware watchdog.
  systemd.settings.Manager = {
    RuntimeWatchdogSec = 0;
  };

  systemd.services.watchdog-feeder = {
    description = "Feed hardware watchdog while Tailscale and systemd are healthy";

    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" "tailscaled.service" ];
    after = [ "network-online.target" "tailscaled.service" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = watchdogFeeder;

      # Important: do not restart the feeder after a failed health check.
      # If it stops feeding, the hardware watchdog should reset the machine.
      Restart = "no";
    };
  };
}