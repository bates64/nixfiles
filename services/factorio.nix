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
        rsync -a --exclude='share/factorio/data/quality' \
          --exclude='share/factorio/data/elevated-rails' \
          --exclude='share/factorio/data/space-age' \
          ${pkgs.factorio-headless}/ $out
      '';
    };
  };
}
