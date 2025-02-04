{ pkgs, lib, config, ... }:
{
  home.packages = with pkgs; [ rustup ] ++ lib.optional (!config.isMacOS) [ clang mold-unwrapped ];
  home.file.".cargo/config.toml".source = ./config.toml;
}
