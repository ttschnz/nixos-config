{ config, pkgs, ... }:
let
  go2faModule = import ./packages/go-2fa.nix { inherit config pkgs; };
in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    # "mailspring-1.12.0"
    # "libav-12.3"
    "electron-25.9.0"
    "openssl-1.1.1w" # required by n-link
  ];

  # RealtimeKit system service
  # hands out realtime scheduling priority to user processes on demand
  security.rtkit.enable = true;
  
  programs.nix-ld.enable = true;

  programs.xonsh = {
    enable = true;
    config = "execx($(atuin init xonsh))";
  };
  # programs.darling.enable = true; # Disable for NIXOS 25.05
  
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = config.sops.secrets."git/name".value;
        email = config.sops.secrets."git/email".value;
        signingkey = config.sops.secrets."ssh/keys/id_ed25519_pub".path;
      };
      gpg = {
        format = "ssh";
      };
    };
  };
  
  programs.bash = {
    # enable = true;
    shellAliases = {
      # cd = "z";
      lspkg = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq";
      # TODO: secrets (2fa)
       vpn = "sudo expect /home/tim/nixos-config/modules/vpn.exp $(cat " + config.sops.secrets."vpn_credentials".path + ") $(2fa tim-epfl)";
    };
  };
  
  environment.gnome.excludePackages = import ./packages/gnome-core-utils.nix { inherit pkgs; };

  environment.systemPackages =
    ## GNOME Extensions & Integration
    import ./packages/gnome-extensions.nix { inherit pkgs; } ++ 

    ## Fonts & LaTeX
    import ./packages/fonts-latex.nix { inherit pkgs; } ++ 

    ## Terminals & Shell Utilities
    import ./packages/terminal-utils.nix { inherit pkgs; } ++ 

    ## Productivity & Office
    import ./packages/productivity-office.nix { inherit pkgs; } ++ 

    ## Browsers & Communication
    import ./packages/browsers-communication.nix { inherit pkgs; } ++ 

    ## Development Tools
    import ./packages/dev.nix { inherit pkgs; } ++ 

    ## Graphics, Audio, Video
    import ./packages/graphics-audio-visual.nix { inherit pkgs; } ++ 

    ## File Transfer & Networking
    import ./packages/filetransfer-networking.nix { inherit pkgs; } ++ 
    
    ## Security & Passwords
    import ./packages/security-passwords.nix { inherit pkgs; } ++ 

    ## Android & Mobile Integration
    import ./packages/android-integration.nix { inherit pkgs; } ++ 

    ## Hardware & Electronics
    import ./packages/hardware-electronics.nix { inherit pkgs; } ++ 
    
    ## Misc
    import ./packages/misc.nix { inherit pkgs; } ++ 
    
    # Modules
    go2faModule.packages;
}