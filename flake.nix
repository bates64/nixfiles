{
  description = "bates64";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
  
    minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";
    minegrub-world-sel-theme.inputs.nixpkgs.follows = "nixpkgs";
  
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  
    # TODO: install nixos-chrome-pwa as a flake
    # https://github.com/Luis-Hebendanz/nixos-chrome-pwa?tab=readme-ov-file#install-as-a-flake
  };

  outputs = {
    self,
    nixpkgs,
    minegrub-world-sel-theme,
    home-manager,
    nixvim,
    ...
  }: let
    home = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./home/bates64/home.nix ];
    };
  in {
    homeConfigurations = {
      bates64 = home;
      alebat01 = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home/alebat01/home.nix ];
      };
    };
    nixosConfigurations = {
      saturn = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/saturn/configuration.nix
          ./tasks/auto-upgrade.nix
          minegrub-world-sel-theme.nixosModules.default

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bates64 = ./home/bates64/home.nix;
          }

          nixvim.nixosModules.nixvim
          ./programs/nixvim.nix
        ];
      };
      apollo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/apollo/configuration.nix
          ./tasks/auto-upgrade.nix

          nixvim.nixosModules.nixvim
          ./programs/nixvim.nix

          ./services/factorio.nix
        ];
      };
    };
  };
}
