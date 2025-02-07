{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.isMacOS {
    home.packages = [ pkgs.aerospace pkgs.sketchybar ];
    home.file.".config/aerospace/aerospace.toml".source = ./aerospace.toml;

    home.file.".config/sketchybar/sketchybarrc" = { source = ./sketchybar/sketchybarrc; executable = true; };
    #home.file.".config/sketchybar/plugins".source = ./sketchybar/plugins;
    #home.file.".config/sketchybar/plugins".recursive = true;
  };
}
