{ config, lib, ... }:
{
  imports = [
    ./auto-upgrade.nix
    ../bates64/all.nix
  ];

  options = {
    isMacOS = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether macOS is in use.";
    };
  };

  config = {
    home.username = "alebat01";
    home.homeDirectory = if config.isMacOS then "/Users/alebat01" else "/home/alebat01";
    programs.git.userEmail = "alex.bates@arm.com";

    home.stateVersion = "24.05";

    programs.home-manager.enable = true;
  };
}
