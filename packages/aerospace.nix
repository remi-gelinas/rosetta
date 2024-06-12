{
  fetchzip,
  stdenv,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "aerospace";
  version = "0.11.2-Beta";

  src = fetchzip {
    url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${version}/AeroSpace-v${version}.zip";
    hash = "sha256-S1jrkU+ovi4KuBPLg59SV0OSx2mhXebT+GKfVb8m/aE=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mkdir -p $out/bin
    cp -r *.app $out/Applications
    install bin/aerospace $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    platforms = platforms.darwin;
  };
}
