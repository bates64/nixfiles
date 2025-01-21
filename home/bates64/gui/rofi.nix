{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = !config.isMacOS;
    font = "FiraCode Nerd Font Mono 10";
    terminal = "kitty";
    theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
        };
        "window" = {
          fullscreen = true;
          padding = mkLiteral "35% 30%";
          transparency = "real";
        };
        "listview" = {
          border = mkLiteral "0 0 0 0";
          padding = mkLiteral "23 0 0";
          scrollbar = true;
        };
        "element" = {
          padding = mkLiteral "2px";
        };
        "inputbar" = {
          spacing = 0;
          padding = mkLiteral "2px";
        };
      };
  };
}
