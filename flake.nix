{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    sops-nix.url = "github:ttschnz/sops-nix";
  };

  outputs = { self, nixpkgs, sops-nix, ... }@inputs: {
    nixosConfigurations = {
      ttschnz = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [

          sops-nix.nixosModules.sops
          ./secrets/secrets.nix

          ./ttschnz/configuration.nix

          ./modules/adb.nix
          ./modules/ti.nix
          ./modules/environment.nix
          ./modules/fonts.nix
          ./modules/networking.nix
          ./modules/printers.nix
          ./modules/users.nix
          ./modules/virtualisation.nix
          ./modules/gnome.nix
          ./modules/drivers.nix

          ./modules/packages.nix
          ./modules/packages/threema.nix
          ./modules/packages/audiveris.nix
          ./modules/packages/neuralnote
          ./modules/packages/msp430debuglib
          ./modules/packages/witr
          ./modules/packages/vscode-wrapped

          ./modules/session_vars.nix

          ./modules/services.nix
          ./modules/services/data_partition.nix
          ./modules/services/docker.nix
          ./modules/services/openssh.nix
          ./modules/services/tor.nix
        ];
      };
      usb = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          sops-nix.nixosModules.sops
          ./secrets/secrets.nix

          ./usb/configuration.nix

          ./modules/adb.nix
          ./modules/environment.nix
          ./modules/fonts.nix
          ./modules/networking.nix
          ./modules/printers.nix
          ./modules/users.nix
          ./modules/virtualisation.nix
          ./modules/gnome.nix
          ./modules/drivers.nix

          ./modules/packages.nix
          ./modules/packages/threema.nix

          ./modules/services.nix
          ./modules/services/data_partition.nix
          ./modules/services/docker.nix
          ./modules/services/openssh.nix
          ./modules/services/tor.nix
        ];
      };
      poseidon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [  
          sops-nix.nixosModules.sops
          ./secrets/secrets.nix

          ./poseidon/configuration.nix

          ./modules/adb.nix
          ./modules/environment.nix
          ./modules/fonts.nix
          ./modules/networking.nix
          ./modules/printers.nix
          ./modules/users.nix
          ./modules/virtualisation.nix
          ./modules/gnome.nix
          ./modules/drivers.nix

          ./modules/packages.nix

          ./modules/services.nix
          ./modules/services/docker.nix
          ./modules/services/openssh.nix
        ];
      };
    };
  };
}
