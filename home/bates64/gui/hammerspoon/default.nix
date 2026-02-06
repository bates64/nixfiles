{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hammerspoon-nix.homeManagerModules.hammerspoon
  ];

  config = lib.mkIf config.isMacOS {
    programs.hammerspoon = {
      enable = true;
      configPath = ./init.lua;
      spoons = {
        PaperWM = pkgs.fetchFromGitHub {
          owner = "mogenson";
          repo = "PaperWM.spoon";
          rev = "41c796a7edd78575aa71b77295672aa0a4a2c3ea";
          sha256 = "0ryck3d6p0rb3zf7wgn83rfn5dqjw98fpbr1cw83jly44sn6d9mv";
        };
        AutoMuteOnSleep = pkgs.fetchzip {
          url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/AutoMuteOnSleep.spoon.zip";
          sha256 = "13llr8j6iwbd5wvsg9mzmzxz06xsnl6mq83bgbnkyk5jbqhzcvxm";
        };
        MouseFollowsFocus = pkgs.fetchzip {
          url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/MouseFollowsFocus.spoon.zip";
          sha256 = "0926nv0bix15p5z1sg1jjjbrkcd2xdxzhj6w8xpqh1nvxb3cp3ac";
        };
      };
    };
  };
}
