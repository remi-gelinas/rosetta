{
  inputs,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.gh-poi = pkgs.callPackage ./package.nix {};
  };
}
