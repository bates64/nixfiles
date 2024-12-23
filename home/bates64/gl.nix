{ config, pkgs, lib, ... }:
let
  # https://github.com/nix-community/nixGL
  useNixGL = !("system" ? config) && !config.isMacOS; # if not NixOS
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
        echo "${pkgs.nixgl.auto.nixGLDefault} \"$file\" \"\$@\"" >> "$newfile"
        chmod +x "$newfile"
      done
    ''
    else package;
in {
  options = {
    wrapGL = lib.mkOption {
      type = lib.types.functionTo lib.types.package;
      default = wrapGL;
    };
  };
}
