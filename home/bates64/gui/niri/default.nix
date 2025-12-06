{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
  ];

  # to use, set `programs.niri.enable = true;` in host configuration
  config = lib.mkIf (!config.isMacOS) {
    xdg.configFile."niri/config.kdl".source = ./config.kdl;
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
    home.packages = with pkgs; [
      xwayland-satellite
      nautilus
    ];

    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = null;
    };

    programs.noctalia-shell = {
      enable = true;
      settings = { };
    };
  };
}
