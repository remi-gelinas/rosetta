{ source
, buildGoModule
,
}:
buildGoModule rec {
  inherit (source) pname version src;
  vendorSha256 = "sha256-D/YZLwwGJWCekq9mpfCECzJyJ/xSlg7fC6leJh+e8i0=";

  doCheck = false;
}
