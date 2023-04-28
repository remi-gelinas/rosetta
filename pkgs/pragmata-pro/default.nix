{
  stdenv,
  lib,
}: let
  version = "0.829";

  meta = {
    description = "PragmataPro™ is a condensed monospaced font optimized for screen.";
    longDescription = ''
      PragmataPro™ is a condensed monospaced font optimized for screen, designed by Fabrizio Schiavi to be the ideal font for coding, math and engineering.
    '';
    homepage = "https://fsd.it/shop/fonts/pragmatapro";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
in
  stdenv.mkDerivation {
    pname = "pragmata-pro";
    inherit version;

    src = ./data;

    installPhase = "install -m444 -Dt $out/share/fonts/truetype *.ttf";

    inherit meta;
  }
