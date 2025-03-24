{ pkgs }:
with pkgs;
{
  aerospace = callPackage ../by-name/ae/aerospace/package.nix { };
  gh-poi = callPackage ../by-name/gh/gh-poi/package.nix { };
}
