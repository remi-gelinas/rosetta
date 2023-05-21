{
  pkgs,
  self',
}: {
  gh-poi = pkgs.callPackage ./gh-poi {};
  emacs = pkgs.callPackage ./emacs {inherit self';};
  wezterm-bin = pkgs.callPackage ./wezterm-bin {};
}
