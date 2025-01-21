{ pkgs, config, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
    package = config.wrapGL { name = "wezterm"; package = pkgs.wezterm; };
  };
}
