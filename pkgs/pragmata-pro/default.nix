{ stdenv, lib }:
let
  version = "0.829";

  meta = {
    description = "";
    longDescription = '''';
    homepage = "";
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
