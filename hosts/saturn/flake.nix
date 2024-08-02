{
  description = "Desktop";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";
  };
  outputs = { self, nixpkgs, minegrub-world-sel-theme, ... }:
    let
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        saturn = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hardware-configuration.nix
            ./configuration.nix
            minegrub-world-sel-theme.nixosModules.default
          ];
        };
      };
  };
}
