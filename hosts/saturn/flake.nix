{
  description = "Desktop";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
  };
  outputs = { self, nixpkgs, minegrub-theme, ... }:
    let
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        saturn = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hardware-configuration.nix
            ./configuration.nix
            minegrub-theme.nixosModules.default
          ];
        };
      };
  };
}
