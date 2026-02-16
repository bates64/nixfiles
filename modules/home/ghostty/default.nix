{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = if config.isMacOS then pkgs.ghostty-bin else pkgs.ghostty;

    # shell integrations needed for nix develop
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      theme = "Catppuccin Mocha";
      font-size = 9;
      background-opacity = if config.isMacOS then 0.8 else 1.0;
      background-blur-radius = 60;
      background = if config.isMacOS then null else "#000000";
      window-padding-x = 8;
      window-padding-y = 8;
      window-padding-balance = true;
      window-padding-color = "extend";
      window-inherit-working-directory = true;
      clipboard-trim-trailing-spaces = true;
      copy-on-select = false;
      macos-titlebar-style = "tabs";
      auto-update = "off";
      cursor-click-to-move = true;
      link-url = true;
      custom-shader = [
        #(toString ./cursor_warp.glsl)
        #(toString ./bloom.glsl)
        (toString ./bettercrt.glsl)
        #(toString ./glitchy.glsl)
      ];
      gtk-single-instance = true;
    };
  };

  xdg.configFile."ghostty/config".force = true;
}
