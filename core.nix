{ lib, config, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "sudo" "zsh-autosuggestions" "zsh-syntax-highlighting" ];
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
    
      window_padding_width = 16;
    };
  };

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
  };
}
