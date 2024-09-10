{ config, pkgs, ... }:

{
  imports = [ ./core.nix ];
   
  programs.git = {
    enable = true;
    userName = "Alex Bates";
    userEmail = "alex.bates@arm.com";
  };
}
