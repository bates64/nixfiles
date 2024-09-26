{ lib, config, pkgs, ... }:

let
  # https://github.com/nix-community/nixGL
  useNixGL = !("system" ? config); # if not NixOS
  wrapGL = { name, package }: # wrap a package's bins with nixGL
    if useNixGL
    then pkgs.runCommand "${name}-wrapped" {} ''
      mkdir -p $out
      cp -r ${package}/* $out
      
      # wrap every binary with nixGL
      mv $out/bin $out/oldbin
      mkdir $out/bin
      for file in "$out/oldbin"/*; do
        filename=$(basename "$file")
        newfile="$out/bin/$filename"

        echo "#!/bin/bash" > "$newfile"
        echo "nixGL \"$file\" \"\$@\"" >> "$newfile"
        chmod +x "$newfile"
      done
    ''
    else package;
in {
  imports = [ ./hm/zsh.nix ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
      window_padding_width = 16;
      update_check_interval = 0;
    };
    shellIntegration.enableZshIntegration = true;
    package = wrapGL { name = "kitty"; package = pkgs.kitty; };
  };

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
  };
}
