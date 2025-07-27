{ pkgs, ... }: {
  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.hypridle.enable = true;
  programs.hyprlock.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    hyprpaper
    hyprpicker
    hyprshot
    hyprsunset
  ];
}
