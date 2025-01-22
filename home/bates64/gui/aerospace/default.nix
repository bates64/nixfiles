{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.isMacOS {
    home.packages = [ pkgs.aerospace ];
    home.file.".config/aerospace/aerospace.toml".source = ./aerospace.toml;
  };
}
