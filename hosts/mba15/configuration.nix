{ pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
	  pkgs.direnv
        ];

      # Auto upgrade nix package and the daemon service.
      nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      security.pam.services.sudo_local.touchIdAuth = true;

      users.users.bates64 = {
        home = "/Users/bates64";
        shell = pkgs.zsh;
      };

      system.primaryUser = "bates64";
      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        screencapture.location = "~/Pictures/screenshots";
        screensaver.askForPasswordDelay = 10;
      };

      # Rosetta
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      nix.settings.trusted-users = [ "@admin" ];
      nix.linux-builder.enable = true;
}
