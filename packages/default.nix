{
  pkgs,
  config,
  inputs,
}: {
  gh-poi = pkgs.callPackage ./gh-poi {};

  emacs = pkgs.callPackage ./emacs {
    inherit (inputs) emacs-unstable;
    inherit config pkgs;
  };
}
