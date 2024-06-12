{
  fetchzip,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
  stdenv,
  lib,
}:
let
  sources = import ../_sources/generated.nix {
    inherit
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };

  src = sources.aerospace;
in
stdenv.mkDerivation {
  inherit (src) pname version;

  src = fetchzip {
    url = "https://github.com/nikitabobko/AeroSpace/releases/download/${src.src.rev}/AeroSpace-${src.src.rev}.zip";
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
