{ config, pkgs, lib, ... }:
let
  msp430debuglib = pkgs.stdenv.mkDerivation {
      name = "ti-msp430-debug-stack-3.15.1.1";

      src = pkgs.fetchurl {
        url = "https://dr-download.ti.com/software-development/driver-or-library/MD-1nw0DC7bd1/3.15.1.1/MSP430_DLL_Developer_Package_Rev_3_15_1_1.zip";
        sha256 = "0b8a0672dfd02e37b60a74a7cf1469c98d6fbb9716923aeee27863b878d63ad4";
      };

      nativeBuildInputs = [ pkgs.unzip ];

      unpackPhase = ''
        unzip $src
      '';

      installPhase = ''
        mkdir -p $out/lib
        cp libmsp430_64.so $out/lib/libmsp430.so
      '';
    };
in 
{
   nixpkgs.overlays = [
    (final: prev: {
      msp430debuglib = msp430debuglib;
    })
  ];
  # environment.systemPackages = [ msp430debuglib ];
}