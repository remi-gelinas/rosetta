{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "Wezterm";
  version = "20230408-112425-69ae8472";

  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/Applications
    cp -avi $src/Wezterm.app $out/Applications/
  '';

  src = pkgs.fetchzip {
    url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
    sha256 = "sha256-JsCcJSqve5Trk8UE7Ma405CyDafw6UPXZA78QZHYrvo=";
  };

  inherit (pkgs.wezterm) meta;
  platforms = lib.platforms.darwin;
}
