{ stdenvNoCC, lib, ... }:
stdenvNoCC.mkDerivation {
  pname = "comic-code";
  version = "1.0";
  src = ./comic-code;
 
  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp -r $src/*.otf $out/share/fonts/truetype/
  '';
 
  meta = with lib; {
    description = "Comic Code";
    homepage = "https://tosche.net/fonts/comic-code";
    platforms = platforms.all;
  };
}
