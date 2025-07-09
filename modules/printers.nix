{config, pkgs, ...}:
{

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.brlaser # Brother MFC-L2710DW
    pkgs.gutenprint 
    pkgs.brgenml1lpr
    pkgs.brgenml1cupswrapper
    pkgs.canon-cups-ufr2 # Canon printers
  ];

  # SANE (Scanner Access Now Easy)
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  hardware.sane.brscan4.enable = true;


  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother-MFC-L2710DW";
        location = "Home";
        deviceUri = "http://192.168.178.9";
        model = "drv:///brlaser.drv/brl2710w.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "EPFL-SecurePrint-Color";
        location = "EPFL"; 
        deviceUri = config.sops.secrets."printer_epfl_printerserver".value + "SecurePrint-Color";
        model = "CNRCUPSIRADVC5860ZK.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
      {
        name = "EPFL-SecurePrint-BW";
        location = "EPFL";
        deviceUri = config.sops.secrets."printer_epfl_printerserver".value + "SecurePrint-BW";
        model = "CNRCUPSIRADVC5860ZK.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
  };
}