{ lib, config, pkgs, ... }:
{
  imports = [
    ./gl.nix
    ./zsh
    ./git.nix
    ./tmux.nix
    ./rofi.nix
    ./bspwm
    ./polybar.nix
    ./wezterm
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];

  programs.vscode = {
    enable = true;
  };

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    mosh # SSH replacement which allows client to lose connection without losing session
  ];
}
