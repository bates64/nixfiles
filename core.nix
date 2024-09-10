{ config, pkgs, ... }:

{
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
}
