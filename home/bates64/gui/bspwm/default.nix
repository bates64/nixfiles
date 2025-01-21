{ config, lib, pkgs, ...}:
{
  config = lib.mkIf (!config.isMacOS) {
    home.file.".xinitrc".source = ./xinitrc;

    xsession.windowManager.bspwm = {
      enable = true;
      startupPrograms = [ "kitty" ];
      extraConfig = ''
        # mouse
        bspc config pointer_action1 move
        bspc config pointer_action2 resize_side
        bspc config pointer_action2 resize_corner
      '';
      monitors = {
        # work desktop
        DP-0 = [ "6" "7" "8" "9" "10" ]; # right
        DP-2 = [ "1" "2" "3" "4" "5" ]; # left
      };
    };

    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + Return" = "kitty";
        "super + @space" = "rofi -show drun -drun-display-format \"\\{name\\}\" -show-icons -matching fuzzy -auto-select";

        # quit bspwm
        "super + alt + q" = "bspc quit";

        # lock screen
        "super + x" = "xsecurelock"; # "${pkgs.xsecurelock}/bin/xsecurelock";

        # directional focus/swap window
        "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";

        # focus/send desktop
        "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";

        # grow window
        "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";

        # shrink window
        "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20, left 20 0}";
      
        # close/kill window
        "super + {_,shift + }q" = "bspc node -{c,k}";

        # bluetooth
        "super + b" = "${pkgs.rofi-bluetooth}/bin/rofi-bluetooth";
      };
    };

    home.packages = with pkgs; [ picom dunst feh dbus ];

    home.file.".config/gtk-3.0/settings.ini".source = ./gtk-3.0-settings.ini;
  };
}
