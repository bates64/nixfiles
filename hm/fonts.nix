{ pkgs, ...}:
let
  comic-code = pkgs.callPackage ../packages/comic-code.nix { inherit pkgs; };
in {
  home.packages = [
    comic-code
  ];

  fonts.fontconfig.enable = true;
}
