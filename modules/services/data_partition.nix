{ config, pkgs, ... }:

{
  # tell cypttab about our encryprted partition
  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      data PARTUUID=2e078986-fdbf-414a-b1dd-b3fda7c88ebd none tcrypt,tcrypt-veracrypt
    '';
  };

  # mount the decryptred partition
  fileSystems = {
    "/home/tim/data" = {
      # device = "/dev/nvme0n1p6"; # before veracrypt
      device = "/dev/mapper/data"; # after veracrypt
      fsType = "ntfs-3g"; 
      options = [
        "rw"
        "x-gvfs-show"
        "nofail"
        "x-systemd.automount" # allow lazy mounting
        "uid=1000"   # user ID (id tim)
        "gid=100"    # shared group 'users'
        "umask=002"  # owner and group can read/write, others can read
        "allow_other" # allow other users to access the filesystem
      ];
    };
  };
  # allow other users to access the filesystem, sets user_allow_other in  /etc/fuse.conf
  programs.fuse.userAllowOther = true; 

  # use the mounted data partition with syncthing
  services.syncthing = {
    user = "tim";
    configDir = "/home/tim/.conifg/syncthing";
    enable = true;
    openDefaultPorts = true;
    settings.gui = {
      user = "tim";
      password = config.sops.secrets."syncthing/web_gui_password".value;
    };

    settings.devices= {
      "pixel6a" = { id = config.sops.secrets."syncthing/pixel6a".value; };
      "samsungtab" = { id = config.sops.secrets."syncthing/samsungtab".value; };
    };

    settings.folders = {
      "Cloud" = {
        path = "/home/tim/data/Cloud";
        devices = [ "pixel6a" "samsungtab" ];
      };
      "Images" = {
        path = "/home/tim/data/Privat/Fotos";
        devices = [ "pixel6a" "samsungtab" ];
      };
      "Documents" = {
        path = "/home/tim/data/Privat/Dokumente";
        devices = [ "pixel6a" ];
      };
      "KeePass" = {
        path = "/home/tim/data/Privat/KeePass";
        devices = [ "pixel6a" "samsungtab" ];
      };
      "Notes" = {
        path = "/home/tim/data/Privat/Notes";
        devices = [ "pixel6a" "samsungtab" ];
      };
      "Backups" = {
        path = "/home/tim/data/Privat/Backups";
        devices = [ "pixel6a" "samsungtab" ];
      };
    };
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";  # Do not create default folder ~/Sync
  # users.users.syncthing.extraGroups = [ "users" ]; # gives syncthing access to /home/tim/data/Cloud, which can be read by group 'users'

  system.userActivationScripts.ln-documents = ''
      [ ! -L ~/Documents ] && rmdir ~/Documents
      ln -sfn /home/tim/data/Privat/Dokumente /home/tim/Documents
    '';

  system.userActivationScripts.ln-pictures = ''
    [ ! -L ~/Pictures ] && rmdir ~/Pictures
    ln -sfn /home/tim/data/Privat/Fotos /home/tim/Pictures
  '';
}