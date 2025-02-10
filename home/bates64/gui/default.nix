{ lib, pkgs, config, ... }:
{
  imports = [
    ../cli
    ./gl.nix
    ./rofi.nix
    ./bspwm
    ./aerospace
    ./polybar.nix
    ./wezterm # TODO: migrate to ghostty, once darwin is fixed
    #./ghostty.nix
    #./zed.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode" "code"
    "spotify"
    "discord"
    "aseprite"
    "nvidia"
  ];

  programs.vscode = {
    enable = true;

    # using fhs fixes some stuff e.g. https://discourse.nixos.org/t/cant-run-c-debugger-in-vscode/33609
    package = if config.isMacOS then pkgs.vscode else pkgs.vscode.fhsWithPackages (ps: with ps; [
      # needed for rust-analyzer
      rustup zlib openssl.dev pkg-config
    ]);
  };

  programs.firefox.enable = true;

  home.packages = with pkgs; [
    fira-code-nerdfont # TODO(25.05): renamed to nerd-fonts.fira-code
    spotify
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
  ] ++ (if config.isMacOS then [] else with pkgs; [
    aseprite # TODO: maintain darwin package
    ares
  ]);

  fonts.fontconfig = {
    enable = !config.isMacOS; # TODO(25.05): fixed on darwin; make always true
    defaultFonts.monospace = ["FiraCode Nerd Font Mono"];
  };
}
