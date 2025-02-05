{ pkgs, lib, config, ... }:
{
  home.packages = with pkgs; [ rustup ] ++ lib.optional (!config.isMacOS) (with pkgs; [ clang mold ]);
  home.file.".cargo/config.toml".source = ./config.toml;
}
