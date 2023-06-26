{callPackage, ...}: {
  builders = import ./builders {inherit callPackage;};
  editors = import ./editors;
  fonts = import ./fonts {inherit callPackage;};
  gh-poi = callPackage ./gh-poi {};
  tart = callPackage ./tart {};
}
