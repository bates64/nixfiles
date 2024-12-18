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
      "minimento"
    ];
    # https://forums.factorio.com/viewtopic.php?t=117096
    package = pkgs.stdenv.mkDerivation {
      name = "factorio-headless-no-space-age";
      src = pkgs.factorio-headless.src;
      buildInputs = [ pkgs.rsync ];
      buildPhase = ''
        mkdir -p $out
        ${pkgs.rsync}/bin/rsync -a --exclude='share/factorio/data/quality' \
          --exclude='share/factorio/data/elevated-rails' \
          --exclude='share/factorio/data/space-age' \
          ${pkgs.factorio-headless}/ $out
      '';
    };
  };
}
