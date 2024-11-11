{
  description = "bates64";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  
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
  }@inputs: {
    # Home PC
    nixosConfigurations.saturn = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/saturn/configuration.nix
        ./tasks/auto-upgrade.nix
        minegrub-world-sel-theme.nixosModules.default

        home-manager.nixosModules.home-manager
        # {
        #   home-manager.useGlobalPkgs = true;
        #   home-manager.useUserPackages = true;

        #   home-manager.users.bates64 = import ./home.nix;
        # }

        nixvim.nixosModules.nixvim
        ./programs/nixvim.nix
      ];
    };

    # 2-core Hetzner server
    nixosConfigurations.apollo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/hyperion/configuration.nix
        ./tasks/auto-upgrade.nix

        nixvim.nixosModules.nixvim
        ./programs/nixvim.nix

        ./services/factorio.nix
      ];
    };
  };
}
