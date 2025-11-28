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
  };

  outputs =
    {
      nixpkgs,
      minegrub-world-sel-theme,
      minecraft-plymouth-theme,
      home-manager,
      nix-darwin,
      nixvim,
      vscode-server,
      nixgl,
      disko,
      nix-minecraft,
      ...
    }:
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
      #
      nixosConfigurations = {
        # PC
        saturn = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = pkgs-x86_64;
          modules = [
            ./hosts/saturn/configuration.nix
            ./tasks/auto-upgrade.nix
            ./tasks/gc.nix
            minegrub-world-sel-theme.nixosModules.default
            minecraft-plymouth-theme.nixosModules.default
            disko.nixosModules.disko

            {
              programs.nix-ld.enable = true;
            }

            # Splash
            {
              boot = {
                plymouth = {
                  enable = true;
                  plymouth-minecraft-theme.enable = true;
                };

                # Enable "Silent boot"
                consoleLogLevel = 3;
                initrd.verbose = false;
                kernelParams = [
                  "quiet"
                  "splash"
                  "boot.shell_on_fail"
                  "udev.log_priority=3"
                  "rd.systemd.show_status=auto"
                ];
              };
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.bates64 = ./home/bates64/gui;
              home-manager.backupFileExtension = "backup";
            }

            nixvim.nixosModules.nixvim
            ./programs/nixvim.nix

            vscode-server.nixosModules.default
            {
              services.vscode-server.enable = true;
            }
          ];
        };
        # Hetzner VPS
        apollo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = pkgs-x86_64;
          modules = [
            ./hosts/apollo/configuration.nix
            ./tasks/auto-upgrade.nix
            ./tasks/gc.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.bates64 = ./home/bates64/cli;
            }

            nixvim.nixosModules.nixvim
            ./programs/nixvim.nix

            vscode-server.nixosModules.default
            {
              services.vscode-server.enable = true;
            }

            nix-minecraft.nixosModules.minecraft-servers
            {
              nixpkgs.overlays = [ nix-minecraft.overlay ];
            }

            ./services/factorio.nix
            #./services/wua-mediawiki.nix # FIXME extensions should use git
            ./services/matchbox.nix
            ./services/minecraft/vanilla.nix
            ./services/minecraft/gtnh
          ];
        };
      };

      # Laptops
      darwinConfigurations = {
        # Macbook Air 15
        mba15 = nix-darwin.lib.darwinSystem {
          pkgs = pkgs-aarch64-darwin;
          modules = [
            ./hosts/mba15/configuration.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.bates64 =
                { ... }:
                {
                  imports = [ ./home/bates64/gui ];
                  isMacOS = true;
                };
            }
          ];
        };
        # (Work) Macbook Pro
        "FH91CFY4QP-2" = nix-darwin.lib.darwinSystem {
          pkgs = pkgs-aarch64-darwin;
          modules = [
            ./hosts/work-mbp/configuration.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alebat01 =
                { ... }:
                {
                  imports = [ ./home/alebat01/home.nix ];
                  isMacOS = true;
                };
            }
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
      };
    };
}
