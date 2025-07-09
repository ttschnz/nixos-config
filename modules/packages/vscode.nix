{ pkgs, ... }: with pkgs; [
  # vscode
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
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
      ];
    })
]