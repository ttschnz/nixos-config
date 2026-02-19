{ config, pkgs, lib, ...}:

{
  # adb group
  users.groups.plugdev = {};
  # adb udev rules (https://lights0123.com/n-link/)
  services.udev.extraRules = lib.mkAfter ''
  # TI-Nspire
  SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e012", ENV{ID_PDA}="1"
  # TI-Nspire CX II
  SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e022", ENV{ID_PDA}="1"
  # MSP430 LaunchPad Hub (0451:2046)
  SUBSYSTEM=="usb", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="2046", MODE="0666", GROUP="plugdev"
  # MSP430 LaunchPad eZ-FET Debugger (0451:f432)  
  SUBSYSTEM=="usb", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="f432", MODE="0666", GROUP="plugdev"
  '';
  
  boot.kernelModules = [ "ti_usb_3410_5052" ];
  hardware.enableRedistributableFirmware = true;
}