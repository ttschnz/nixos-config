{ config, pkgs, ... }:

{

  #virtualisation.waydroid.enable = true;

  # Set up virtualisation
  virtualisation.libvirtd = {
      enable = true;

      # Enable TPM emulation (for Windows 11)
      qemu = {
        swtpm.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };

  # Enable USB redirection
  virtualisation.spiceUSBRedirection.enable = true;
}