{ ... }:
{
  services.polybar = {
    enable = true;
    script = ''
      polybar main &
      polybar secondary &
    '';
    settings = {
      "bar/main" = {
        top = true;
        monitor = "DP-0";
        width = "100%";
        height = "24pt";
        modules.left = "bspwm";
        modules.center = "date";
      };
      "bar/secondary" = {
        top = true;
        monitor = "DP-2";
        width = "100%";
        height = "24pt";
        modules.left = "bspwm";
      };
      "module/bspwm" = {
        type = "internal/bspwm";
        label-focused-background = "#3f3f3f";
        label.empty.foreground = "#55";
        label-separator-padding = 2;
      };
      "module/date" = {
        type = "internal/date";
        date = "%I:%M %p    %a %b %d";
      };
    };
  };
}
