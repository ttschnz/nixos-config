{ ... }:
{
  services.syncthing = {
    enable = false;
    user = "tim";
    configDir = "/home/tim/.config/syncthing";
    openDefaultPorts = true;
    
    settings.devices= {
      "ttschnz" =    { id = "WNZ7AN6-BGFBQJD-IPAGT5T-VQSMSFX-3WWU4IJ-D2UY2FJ-ZIHFEXP-IZ5D7QO"; };
      "pixel6a" =    { id = "3VHMALT-3ZSXELT-FEAED5U-DOSE7JU-7TYCBGQ-VL4MRAD-UYXTMKB-J44MBQX"; };
      "samsungtab" = { id = "ZCD7Q4I-NLKFTR2-DPZ5BM5-73FKOM7-URM6K5J-UAOZAZ3-X7XU7HY-ZCTHXQD"; };
    };

    settings.folders = {
      "Cloud" = {
        path = "/data/tim/syncthing/cloud";
        devices = [ "pixel6a" "samsungtab" "ttschnz" ];
      };
      "Documents" = {
        path = "/data/tim/syncthing/documents";
        devices = [ "pixel6a" "ttschnz" ];
      };
      "Notes" = {
        path = "/data/tim/syncthing/notes";
        devices = [ "pixel6a" "samsungtab" "ttschnz" ];
      };
      "Backups" = {
        path = "/data/tim/syncthing/backups";
        devices = [ "pixel6a" "samsungtab" "ttschnz" ];
      };
    };
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";  # Do not create default folder ~/Sync
}