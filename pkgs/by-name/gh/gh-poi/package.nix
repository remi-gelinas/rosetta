{
  buildGoModule,
  callPackage,
  sources ? callPackage ./sources.nix { },
}:
buildGoModule {
  inherit (sources.gh-poi)
    pname
    version
    src
    vendorHash
    ;

  doCheck = false;
}
