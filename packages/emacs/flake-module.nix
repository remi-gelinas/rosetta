_: {
  perSystem = {pkgs, ...}: {
    packages.emacs = pkgs.callPackage ./package.nix {};
  };
}
