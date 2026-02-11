{
  lib,
  pkgs,
  config,
  ...
}:
let
  ares-wrapped =
    if config.isMacOS then
      pkgs.ares.overrideAttrs (oldAttrs: {
        postFixup = ''
          ${oldAttrs.postFixup}
          ln -s $out/Applications/ares.app/Contents/MacOS/ares $out/bin/ares
        '';
      })
    else
      pkgs.ares;
in
{
  imports = [
    ./headless.nix
    ../gl.nix
    ../niri
    ../hammerspoon
    ../ghostty
    ../zed.nix
    ../intellij.nix
    ../browser.nix
  ];

  programs.vscode = {
    enable = true;

    # using fhs fixes some stuff e.g. https://discourse.nixos.org/t/cant-run-c-debugger-in-vscode/33609
    package =
      if config.isMacOS then
        pkgs.vscode
      else
        pkgs.vscode.fhsWithPackages (
          ps: with ps; [
            # needed for rust-analyzer
            rustup
            zlib
            openssl.dev
            pkg-config
          ]
        );
  };

  home.packages =
    with pkgs;
    [
      nerd-fonts.fira-code
      inter-nerdfont
      vesktop
      ares-wrapped
      obsidian
    ]
    ++ (
      if config.isMacOS then
        [ ]
      else
        with pkgs;
        [
          aseprite # TODO: maintain darwin package
        ]
    );
}
