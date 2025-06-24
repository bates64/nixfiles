{ lib, pkgs, config, ... }:
let
  # on macOS, override ares so that `ares` works in the shell
  ares-wrapped = if config.isMacOS then pkgs.ares.overrideAttrs (oldAttrs: {
    postFixup = ''
      ${oldAttrs.postFixup}
      ln -s $out/Applications/ares.app/Contents/MacOS/ares $out/bin/ares
    '';
  }) else pkgs.ares;
in {
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

  programs.firefox.enable = !config.isMacOS; # currently broken on darwin (package.meta.badPlatforms)

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    spotify
    (discord.override {
      withOpenASAR = !config.isMacOS;
      withVencord = !config.isMacOS;
    })
    ares-wrapped
  ] ++ (if config.isMacOS then [] else with pkgs; [
    aseprite # TODO: maintain darwin package
  ]);

  fonts.fontconfig.defaultFonts.monospace = ["FiraCode Nerd Font Mono"];
}
