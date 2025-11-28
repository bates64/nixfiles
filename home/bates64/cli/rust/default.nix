{ pkgs, config, ... }:
{
  home.packages =
    with pkgs;
    [
      rustup
    ]
    ++ (
      if config.isMacOS then
        [ ]
      else
        with pkgs;
        [
          clang
          mold
          wild-unwrapped
        ]
    );
  home.file.".cargo/config.toml".source = ./config.toml;
}
