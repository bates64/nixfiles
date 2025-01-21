{ pkgs, ... }:
{
  home.packages = with pkgs; [ rustup mold-wrapped clang ];
  home.file.".cargo/config.toml".source = ./config.toml;
}
