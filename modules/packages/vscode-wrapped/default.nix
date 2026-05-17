{
  nixpkgs.overlays = [
    (final: prev:

      let
        devLibPath = final.lib.makeLibraryPath [
          final.gcc-unwrapped.lib
          final.msp430debuglib
          final.libusb-compat-0_1
        ];

        chordproExtension =
          final.callPackage ./extensions/ricardomfmsousa.chordpro { };

      in {
        vscode-wrapped =
          final.symlinkJoin {
            name = "vscode-with-extensions-wrapped";

            paths = [
              (final.vscode-with-extensions.override {
                vscodeExtensions =
                  (with final.vscode-extensions; [
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
                  ])
                  ++ [
                    chordproExtension
                  ];
              })
            ];

            buildInputs = [ final.makeWrapper ];

            postBuild = ''
              wrapProgram $out/bin/code \
                --set LD_LIBRARY_PATH "${devLibPath}"
            '';
          };
      })
  ];
}