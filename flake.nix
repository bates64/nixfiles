{
  description = "bates64";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";
    minegrub-world-sel-theme.inputs.nixpkgs.follows = "nixpkgs";

    minecraft-plymouth-theme.url = "github:nikp123/minecraft-plymouth-theme";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: install nixos-chrome-pwa as a flake
    # https://github.com/Luis-Hebendanz/nixos-chrome-pwa?tab=readme-ov-file#install-as-a-flake

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hammerspoon-nix = {
      url = "github:DivitMittal/hammerspoon-nix";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      nixgl,
      ...
    }@inputs:
    let
      pkgs-x86_64 = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nixgl.overlay ];
        config.allowUnfree = true;
      };
      pkgs-aarch64-darwin = import nixpkgs {
        system = "aarch64-darwin";
        overlays = [ nixgl.overlay ];
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        # Desktop PC
        merlon = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = pkgs-x86_64;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/merlon/configuration.nix
            home-manager.nixosModules.home-manager
          ];
        };
        # Hetzner VPS
        merlow = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = pkgs-x86_64;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/merlow/configuration.nix
            home-manager.nixosModules.home-manager
          ];
        };
        # Homelab
        watt = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = pkgs-x86_64;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/watt/configuration.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };

      darwinConfigurations = {
        # MacBook Air 15
        nolrem = nix-darwin.lib.darwinSystem {
          pkgs = pkgs-aarch64-darwin;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nolrem/configuration.nix
            home-manager.darwinModules.home-manager
          ];
        };
        # (Work) MacBook Pro
        "FH91CFY4QP-2" = nix-darwin.lib.darwinSystem {
          pkgs = pkgs-aarch64-darwin;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/work-mbp/configuration.nix
            home-manager.darwinModules.home-manager
          ];
        };
      };

      # (Work) Headless machine
      homeConfigurations.alebat01 = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-x86_64;
        modules = [
          ./home/alebat01/home.nix # TODO: no need for GUI
          ./home/alebat01/auto-upgrade.nix
        ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
}
