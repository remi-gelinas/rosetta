{
  buildGo121Module,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}:
let
  sources = import ../../_sources/generated.nix {
    inherit
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };
in
buildGo121Module {
  inherit (sources.gh-poi) pname version src;
  vendorHash = "sha256-D/YZLwwGJWCekq9mpfCECzJyJ/xSlg7fC6leJh+e8i0=";
  doCheck = false;
}
