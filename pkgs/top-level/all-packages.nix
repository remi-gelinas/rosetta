{ pkgs }:
with pkgs;
{
  aerospace = callPackage ../by-name/ae/aerospace/package.nix { };
  foundry = callPackage ../by-name/fo/foundry/package.nix { };
  gh-poi = callPackage ../by-name/gh/gh-poi/package.nix { };
  safecard-cli = callPackage ../by-name/sa/safecard-cli/package.nix { };
  soldeer = callPackage ../by-name/so/soldeer/package.nix { };
}
