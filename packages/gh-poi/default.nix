{ buildGo121Module }:
let
  npins = import ../../npins;
in
buildGo121Module {
  pname = "gh-poi";
  version = npins.gh-poi.revision;
  src = npins.gh-poi;
  vendorHash = "sha256-D/YZLwwGJWCekq9mpfCECzJyJ/xSlg7fC6leJh+e8i0=";
  doCheck = false;
}
