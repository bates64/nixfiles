{ config, lib, ... }:
{
  imports = [
    ./auto-upgrade.nix
    ./ssh.nix
    ../bates64/cli
    ../bates64/gui
  ];
  config = {
    home.username = "alebat01";
    home.homeDirectory = if config.isMacOS then "/Users/alebat01" else "/home/alebat01";
    programs.git.userEmail = "alex.bates@arm.com";

    home.stateVersion = "24.05";

    programs.home-manager.enable = true;
  };
}
