{ config, pkgs, lib, ... }:

{
  environment.variables.LD_LIBRARY_PATH = lib.mkForce (
    lib.makeLibraryPath [
      pkgs.gcc-unwrapped.lib
      pkgs.msp430debuglib
      pkgs.libusb-compat-0_1
    ] + ":/etc/sane-libs"
  );
}