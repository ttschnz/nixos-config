{ config, pkgs, lib, ... }:

let
  pool = "data";

  # BCM GPIO23 on the Raspberry Pi main GPIO controller.
  # This is line offset 23 on gpiochip0, not physical header pin number 23.
  gpioChip = "gpiochip0";
  gpioLine1 = "23";
  gpioLine2 = "24";

  spinupSeconds = "3";
  importDir = "/dev/disk/by-id";

  gpioset = "${pkgs.libgpiod}/bin/gpioset";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  udevadm = "${pkgs.systemd}/bin/udevadm";
  sleep = "${pkgs.coreutils}/bin/sleep";
  findmnt = "${pkgs.util-linux}/bin/findmnt";
  tailscale = "${pkgs.tailscale}/bin/tailscale";
  jq = "${pkgs.jq}/bin/jq";
  curl = "${pkgs.curl}/bin/curl";


  zfsPkg = config.boot.zfs.package;
  zpool = "${zfsPkg}/bin/zpool";
  zfs = "${zfsPkg}/bin/zfs";

  qPool = lib.escapeShellArg pool;
  qImportDir = lib.escapeShellArg importDir;

  hddZpoolOn = pkgs.writeShellScript "hdd-zpool-on" ''
    set -euo pipefail
    
    # switch gpio output from off (0) to on (1)
    ${systemctl} stop hdd-power-off-hold.service || true
    ${systemctl} start hdd-power-on-hold.service

    # wait for disks to start
    ${sleep} ${spinupSeconds}
    ${udevadm} settle --timeout=30 || true

    # wait until pool is here, max 30 retries at 1s
    if ! ${zpool} list -H -o name ${qPool} >/dev/null 2>&1; then
      for i in $(seq 1 30); do
        if ${zpool} import -d ${qImportDir} -N ${qPool}; then
          break
        fi
        ${sleep} 1
        ${udevadm} settle --timeout=5 || true
      done
    fi

    # check if pool is here and power off if failed
    if ! ${zpool} list -H -o name ${qPool} >/dev/null 2>&1; then
      echo "Failed to import ZFS pool ${pool}" >&2
      ${zpool} import || true
      ${systemctl} stop hdd-power-on-hold.service || true
      ${systemctl} start hdd-power-off-hold.service || true
      exit 1
    fi

    # load encryption key
    ${zfs} load-key -r ${qPool}

    # mount pool
    ${zfs} mount -a

    # verify if mounted or fail
    if ${zfs} list -H -r -o mounted ${qPool} | grep -q '^no$'; then
      echo "Some datasets in ${pool} are not mounted; refusing to start hdd-zpool.target" >&2
      ${zfs} list -r -o name,keystatus,mounted,mountpoint,canmount ${qPool} >&2
      ${zpool} export ${qPool} || true
      ${systemctl} stop hdd-power-on-hold.service || true
      ${systemctl} start hdd-power-off-hold.service || true
      exit 1
    fi
    
    # print status
    ${zpool} status ${qPool}

    # notify other services that the storage is ready
    ${systemctl} start hdd-zpool.target
    # restart beszel agent now that it can monitor the /data mount
    ${systemctl} try-restart beszel-agent.service
  '';

  hddZpoolOff = pkgs.writeShellScript "hdd-zpool-off" ''
    set -euo pipefail
    # stop services that depend on the zpool
    ${systemctl} stop hdd-zpool.target

    # export (=>disable) the pool
    if ${zpool} list -H -o name ${qPool} >/dev/null 2>&1; then
      ${zpool} export ${qPool}
    fi

    # switch gpio output from on (1) to off (0)
    ${systemctl} stop hdd-power-on-hold.service || true
    ${systemctl} start hdd-power-off-hold.service
  '';

  hddZpoolAutoSleep = pkgs.writeShellScript "hdd-zpool-autosleep" ''
    set -euo pipefail

    stateDir="/run/hdd-zpool-autosleep"
    stateFile="$stateDir/offline-count"
    offlineLimit=10   # 10 checks * 30 s = 5 min offline before poweroff

    mkdir -p "$stateDir"

    if [ ! -f "$stateFile" ]; then
      echo 0 > "$stateFile"
    fi

    # Do not change disk state if tailscale status itself fails.
    # This avoids powering off because tailscaled temporarily misbehaved.
    if ! status="$(${tailscale} status --json 2>/dev/null)"; then
      echo "tailscale status failed; leaving current disk state unchanged" >&2
      exit 0
    fi

    # if anyone is connected, reset state to 0 and start zfs pool if not done yet
    if echo "$status" | ${jq} -e 'any(.Peer[]?; .Online == true)' >/dev/null; then
      echo 0 > "$stateFile"

      if ! ${systemctl} -q is-active hdd-zpool.target; then
        echo "At least one Tailscale peer online; starting HDD/ZFS"
        ${curl} -X POST ntfy.sh/hdd-pool-power_castor --data "At least one Tailscale peer online; starting HDD/ZFS"
        ${systemctl} start hdd-zpool-on.service
      else
        echo "At least one Tailscale peer online; HDD/ZFS already active"
      fi
    else
      count="$(cat "$stateFile")"
      count="$((count + 1))"
      echo "$count" > "$stateFile"
      
      echo "No Tailscale peers online; offline count $count/$offlineLimit"

      if [ "$count" -ge "$offlineLimit" ]; then
        if ${systemctl} -q is-active hdd-zpool.target; then
          echo "Offline threshold reached; stopping HDD/ZFS"
          ${curl} -X POST ntfy.sh/hdd-pool-power_castor --data "Offline threshold reached; stopping HDD/ZFS"
          ${systemctl} start hdd-zpool-off.service
        else
          echo "Offline threshold reached; HDD/ZFS already inactive"
        fi
      fi
    fi
  '';

  waitForGpio = pkgs.writeShellScript "wait-for-gpiochip0" ''
    set -euo pipefail

    # max 50*0.2=10 seconds time to find device or fail
    i=0
    while [ "$i" -lt 50 ]; do
      if [ -e /dev/${gpioChip} ]; then
        exit 0
      fi
      i=$((i + 1))
      ${sleep} 0.2
    done

    echo "/dev/${gpioChip} did not appear" >&2
    exit 1
  '';

  poolDependentService = {
    partOf = [ "hdd-zpool.target" ];
    after = [ "hdd-zpool.target" ];
    # replace existing boot enablement
    wantedBy = lib.mkForce [ "hdd-zpool.target" ];
    # do not use requiresMountsFor = [ "/data" ];, it will try to mount it itself.
    # use this instead, only starts if /data is a mountpoint (passive check)
    unitConfig.ConditionPathIsMountPoint = "/data";
  };
in
{
  environment.systemPackages = [
    pkgs.libgpiod
    zfsPkg
  ];

  # target that represents zfs pool state
  systemd.targets.hdd-zpool = {
    description = "Services requiring HDD-backed ZFS pool";
  };

  systemd.services."immich-server" = poolDependentService;
  systemd.services."redis-immich" = poolDependentService;

  systemd.services."syncthing" = poolDependentService;
  systemd.services."syncthing-init" = poolDependentService;

  systemd.targets.samba = {
    wantedBy = lib.mkForce [ "hdd-zpool.target" ];
    partOf = [ "hdd-zpool.target" ];
    after = [ "hdd-zpool.target" ];
  };
  systemd.services."samba-smbd" = poolDependentService;
  systemd.services."samba-nmbd" = poolDependentService;
  systemd.services."samba-winbindd" = poolDependentService;
  systemd.services."samba-wsdd" = poolDependentService;



  # Internal: holds relay HIGH (1) while running.
  systemd.services.hdd-power-on-hold = {
    description = "Hold HDD relay GPIO high";
    conflicts = [ "hdd-power-off-hold.service" ];

    serviceConfig = {
      Type = "simple";
      ExecStartPre = waitForGpio;
      ExecStart = "${gpioset} -c ${gpioChip} ${gpioLine1}=1 ${gpioLine2}=1";
      Restart = "always";
      RestartSec = "200ms";
    };
  };

  # Internal: holds relay LOW while running.
  # Enabled by default so the disk stays off after boot.
  systemd.services.hdd-power-off-hold = {
    description = "Hold HDD relay GPIO low";
    wantedBy = [ "multi-user.target" ];
    conflicts = [ "hdd-power-on-hold.service" ];
    
    serviceConfig = {
      Type = "simple";
      ExecStartPre = waitForGpio;
      ExecStart = "${gpioset} -c ${gpioChip} ${gpioLine1}=0 ${gpioLine2}=0";
      Restart = "always";
      RestartSec = "200ms";
    };
  };

  # User-facing: power disk, import pool, mount datasets.
  systemd.services.hdd-zpool-on = {
    description = "Power on HDD and import/mount ZFS pool";
    
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = waitForGpio;
      ExecStart = hddZpoolOn;
      TimeoutStartSec = "120s";
    };
  };

  # User-facing: export pool, then power disk off.
  systemd.services.hdd-zpool-off = {
    description = "Export ZFS pool and power off HDD";
    
    # TODO: power disks off when shutting down
    # wantedBy = [ "shutdown.target" ];
    # before = [ "shutdown.target" ];
    # conflicts = [ "shutdown.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = hddZpoolOff;
      TimeoutStartSec = "120s";
      RemainAfterExit = false;
    };
  };

  # Auto turn pools off and on based on tailscale connections
  systemd.services.hdd-zpool-autosleep = {
    description = "Automatically power HDD/ZFS based on online Tailscale peers";

    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = hddZpoolAutoSleep;
      RemainAfterExit = false;
    };
  };

  systemd.timers.hdd-zpool-autosleep = {
    description = "Periodically check whether HDD/ZFS should be powered";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "30s";
      AccuracySec = "5s";
      Unit = "hdd-zpool-autosleep.service";
    };
  };
}