{
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "tart";
  version = "1.6.0";

  src = fetchzip {
    url = "https://github.com/cirruslabs/tart/releases/download/${version}/tart.tar.gz";
    hash = "sha256-V7fwai556KICGXIaoxjEvmxhS2nssqZCs9Vd/VL+0kQ=";
    stripRoot = false;
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/Applications
    mkdir -p $out/bin
    cp -r tart.app $out/Applications/

    ln -s $out/Applications/tart.app/Contents/MacOS/tart $out/bin/tart
  '';
}
