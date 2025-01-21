{ lib, config, ... }:
{
  imports = [
    ./shell
    ./git.nix
    #./tmux.nix
    ./rust
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
    home.username = lib.mkDefault "bates64";
    home.homeDirectory = lib.mkDefault (if config.isMacOS then "/Users/bates64" else "/home/bates64");
    home.stateVersion = lib.mkDefault "22.11";
    programs.home-manager.enable = true;
  };
}
