{ lib, stdenv, fetchzip, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "0.9.2";
  pname = "star-rod";

  src = fetchzip {
    url = "https://github.com/z64a/star-rod/releases/download/v0.9.2/StarRod-0.9.2.zip";
    hash = "sha256-NFYfmsRWS0RIybCG4CpON09rzRurHYVUhkzzGUaEjDc=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/java
    mv * $out/share/java
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/star-rod \
      --add-flags "-cp $out/share/java/StarRod.jar app.StarRodMain"
  '';

  meta = with lib; {
    homepage = "https://github.com/z64a/star-rod";
    description = "Tools for editing Paper Mario 64 assets";
    mainProgram = "star-rod";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
