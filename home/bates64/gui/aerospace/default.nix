{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.isMacOS {
    home.packages = [ pkgs.aerospace pkgs.sketchybar ];
    home.file.".config/aerospace/aerospace.toml".source = ./aerospace.toml;
    launchd.agents.aerospace = {
      enable = true;
      config = {
        Program = "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace";
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/aerospace.log";
        StandardErrorPath = "/tmp/aerospace.err.log";
      };
    };

    home.file.".config/sketchybar/sketchybarrc" = { source = ./sketchybar/sketchybarrc; executable = true; };
    #home.file.".config/sketchybar/plugins".source = ./sketchybar/plugins;
    #home.file.".config/sketchybar/plugins".recursive = true;
  };
}
