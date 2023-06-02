{callPackage, ...}: {
  builders = import ./builders {inherit callPackage;};
  editors = import ./editors;
  gh-poi = callPackage ./gh-poi {};
  fonts = import ./fonts {inherit callPackage;};
}
