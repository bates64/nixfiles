{ lib, pkgs, ... }:
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
    #./zed.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" "nvidia" ];

  programs.vscode = {
    enable = true;
  };

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    mosh # SSH replacement which allows client to lose connection without losing session
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = "FiraCode Nerd Font Mono";
  };
}
