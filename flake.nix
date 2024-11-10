{
  description = "bates64";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";
  };

  outputs = {
    self,
    nixpkgs,
    minegrub-world-sel-theme,
    ...
  }@inputs: {
    nixosConfigurations.saturn = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/saturn/configuration.nix
        ./tasks/auto-upgrade.nix
        minegrub-world-sel-theme.nixosModules.default
      ];
    };
  };
}
