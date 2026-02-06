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
      font-size = 12;
      background-opacity = 0.8;
      background-blur-radius = 60;
      window-padding-x = 4;
      window-padding-y = 4;
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
        #(toString ./bettercrt.glsl)
      ];
      gtk-single-instance = true;
    };
  };

  xdg.configFile."ghostty/config".force = true;
}
