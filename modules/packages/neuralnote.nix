{ config, pkgs, lib, ... }:

let
  neuralnote = pkgs.stdenvNoCC.mkDerivation {
    pname = "neuralnote-standalone";
    version = "1.1.0";

    src = pkgs.fetchzip {
      url = "https://github.com/DamRsn/NeuralNote/releases/download/v1.1.0/NeuralNote_Standalone_Linux.zip";
      sha256 = "sha256-Yi7Fj6kqTRAdwACUPvQwc5mqUMtkejkzGQCSLeWV8uU==";
    };

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];

    buildInputs = with pkgs; [
      fontconfig
      freetype
      alsa-lib

      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXinerama
      xorg.libXi
      xorg.libXrender
      xorg.libxcb

      mesa
      libGL
      wayland
    ];

    installPhase = ''
      mkdir -p $out/opt/neuralnote
      cp -r ./* $out/opt/neuralnote
      chmod +x $out/opt/neuralnote/NeuralNote

      mkdir -p $out/bin
      ln -s $out/opt/neuralnote/NeuralNote $out/bin/neuralnote
    '';

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "neuralnote";
        desktopName = "NeuralNote";
        exec = "neuralnote";
        categories = [ "Audio" "Music" ];
      })
    ];
  };
in
{
  environment.systemPackages = [ neuralnote ];
}
