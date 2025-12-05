{
  config,
  lib,
  pkgs,
  ...
}:
{
  # to use, set `programs.niri.enable = true;` in host configuration
  config = lib.mkIf (!config.isMacOS) {
    xdg.configFile."niri/config.kdl".source = ./config.kdl;

    programs.waybar.enable = true;

    services.mako.enable = true; # Notification daemon
    services.swayidle =
      let
        lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
        display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
      in
      {
        enable = true;
        timeouts = [
          {
            timeout = 5 * 60; # in seconds
            command = "${pkgs.libnotify}/bin/notify-send 'Locking in 30 seconds' -t 5000";
          }
          {
            timeout = 5 * 60 + 30;
            command = lock;
          }
          {
            timeout = 6 * 60;
            command = display "off";
            resumeCommand = display "on";
          }
          {
            timeout = 30 * 60;
            command = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
        events = [
          {
            event = "before-sleep";
            command = (display "off") + "; " + lock;
          }
          {
            event = "after-resume";
            command = display "on";
          }
          {
            event = "lock";
            command = (display "off") + "; " + lock;
          }
          {
            event = "unlock";
            command = display "on";
          }
        ];
      };

    services.polkit-gnome.enable = true;

    home.packages = with pkgs; [
      xwayland-satellite
      brightnessctl
      playerctl
    ];

    home.file.".config/gtk-3.0/settings.ini".source = ./gtk-3.0-settings.ini;
  };
}
