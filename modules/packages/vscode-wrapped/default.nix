{ pkgs, lib, ... }:

let
  devLibPath = lib.makeLibraryPath [
    pkgs.gcc-unwrapped.lib
    pkgs.msp430debuglib
    pkgs.libusb-compat-0_1
  ];

  vscode-wrapped =
    pkgs.symlinkJoin {
      name = "vscode-with-extensions-wrapped";
      paths = [
        (pkgs.vscode-with-extensions.override {
          vscodeExtensions = with pkgs.vscode-extensions; [
            #ms-vscode.cpptools # Temp deactivate
            ms-vscode.cmake-tools
            rust-lang.rust-analyzer
            # unstable.vscode-extensions.rust-lang.rust-analyzer
            esbenp.prettier-vscode
            tamasfe.even-better-toml
            mechatroner.rainbow-csv
            pkief.material-icon-theme
            bbenoist.nix    
            jnoortheen.nix-ide
            ms-vscode-remote.remote-ssh
            ms-python.python
            github.copilot
            # sbrink.elm
            elmtooling.elm-ls-vscode
            # vue.volar
            ms-toolsai.jupyter

            # arduino development
            platformio.platformio-vscode-ide
            ms-vscode.cpptools
            hbenl.vscode-test-explorer
            ms-vscode.test-adapter-converter

          ];
        })
      ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/code \
          --set LD_LIBRARY_PATH "${devLibPath}"
      '';
    };

in
{
  nixpkgs.overlays = [
    (final: prev: {
        vscode-wrapped = vscode-wrapped;
    })
  ];
}