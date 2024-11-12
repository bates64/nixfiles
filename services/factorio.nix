{ pkgs, ... }: {
  services.factorio = {
    enable = true;
    nonBlockingSaving = true;
    openFirewall = true;
    allowedPlayers = [
      "bates64"
      "AgsterMC"
      "asparagoose"
      "spchee"
      "IntactLightbulb"
    ];
    # https://forums.factorio.com/viewtopic.php?t=117096
    package = pkgs.stdenv.mkDerivation {
      name = "factorio-headless-no-space-age";
      src = pkgs.factorio-headless.src;
      buildPhase = ''
        mkdir -p $out
        cp -r ${pkgs.factorio-headless}/. $out
        rm -rf $out/share/factorio/data/quality
        rm -rf $out/share/factorio/data/elevated-rails
        rm -rf $out/share/factorio/data/space-age
      '';
    };
  };
}
