{ config, pkgs, ... }:

{
  services = {
    samba = {
      enable = true;
      openFirewall = true;

      settings = {
        global = {
          "server min protocol" = "SMB3_00";
          "map to guest" = "Never";
          "usershare allow guests" = "no";
          "smb3 unix extensions" = "yes";
        };
        tim = {
          comment = "Tim's Home";
          path = "/data/tim";
          browsable = "yes";
          writable = "yes";
          "create mask" = "0600";
          "directory mask" = "0700";
        };
        tim_backup = {
          comment = "Borg backup destination";
          path = "/data/backup";
          browsable = "yes";
          writable = "yes";
          "create mask" = "0600";
          "directory mask" = "0700";
        };
        shared = {
          comment = "Shared folder";
          path = "/data/shared";
          browsable = "yes";
          writable = "yes";
          "create mask" = "0664";
          "directory mask" = "0775";
          "force group" = "users";
        };
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };

  # # add user passwords
  # systemd.services.samba-smbd.postStart =
  #   let
  #     users = [ "tim" ];
  #     setupUser = user:
  #       let
  #         passwordPath = config.sops.secrets."castor/user/${user}-pw-clear".path;
  #         smbpasswd = "${config.services.samba.package}/bin/smbpasswd";
  #       in ''
  #         printf '%s\n%s\n' "$(<${passwordPath})" "$(<${passwordPath})" | ${smbpasswd} -s -a ${user}
  #       '';
  #   in ''
  #     ${builtins.concatStringsSep "\n" (map setupUser users)}
  #   '';
}