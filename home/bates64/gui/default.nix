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
    ./ghostty.nix
    ./zed.nix
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
    vesktop
    ares-wrapped
    obsidian
    # 25.11
    #nofficial-homestuck-collection
  ] ++ (if config.isMacOS then [] else with pkgs; [
    aseprite # TODO: maintain darwin package
  ]);

  fonts.fontconfig.defaultFonts.monospace = ["FiraCode Nerd Font Mono"];
}
