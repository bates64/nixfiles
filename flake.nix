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

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    minegrub-world-sel-theme,
    home-manager,
    nixvim,
    vscode-server,
    nixgl,
    ...
  }: let
    pkgs-x86_64 = import nixpkgs {
      system = "x86_64-linux";
      overlays = [ nixgl.overlay ];
    };
    pkgs-aarch64-darwin = import nixpkgs {
      system = "aarch64-darwin";
      overlays = [ nixgl.overlay ];
    };
    home = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs-x86_64;
      modules = [ ./home/bates64/home.nix ];
    };
  in {
    homeConfigurations = {
      bates64 = home;
      alebat01 = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-x86_64;
        modules = [ ./home/alebat01/home.nix ];
      };
    };
    packages.aarch64-darwin.homeConfigurations = {
      alex = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-aarch64-darwin;
        modules = [ ./home/bates64/home.nix { isMacOS = true; } ];
      };
      alebat01 = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-aarch64-darwin;
        modules = [ ./home/alebat01/home.nix { isMacOS = true; } ];
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

          vscode-server.nixosModules.default
          {
            services.vscode-server.enable = true;
          }
        ];
      };
      apollo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/apollo/configuration.nix
          ./tasks/auto-upgrade.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bates64 = ./home/bates64/home.nix;
          }

          nixvim.nixosModules.nixvim
          ./programs/nixvim.nix

          vscode-server.nixosModules.default
          {
            services.vscode-server.enable = true;
          }

          ./services/factorio.nix
        ];
      };
    };
  };
}
