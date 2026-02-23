{ config, pkgs, lib, ... }:
let
   witr = pkgs.buildGoModule rec {
    pname = "witr";
    rev = "v0.3.0";
    version = "git-${rev}";
    commit = rev;

    src = pkgs.fetchFromGitHub {
      owner = "pranshuparmar";
      repo = "witr";
      rev = rev;
      sha256 = "XKFFVFuOJN2XtrckjiKkfWW+eRFG/Gk6eHzNvo75D2A=";
    };

    vendorHash = null;

    ldflags = [
      "-X main.version=v${version}"
      "-X main.commit=${commit}"
    ];

    nativeBuildInputs = [ pkgs.installShellFiles ];

    postInstall = ''
      installManPage ./doc/witr.*
    '';

    meta = with lib; {
      description = "Why is this running?";
      homepage = "https://github.com/pranshuparmar/witr";
      license = licenses.asl20;
    };
  };
in 
{
   nixpkgs.overlays = [
    (final: prev: {
      witr = witr;
    })
  ];
}  
