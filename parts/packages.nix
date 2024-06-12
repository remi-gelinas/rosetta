{
  perSystem =
    { lib, pkgs, ... }:
    with lib;
    {
      options.rosetta.packages =
        with types;
        mkOption { type = submodule { freeformType = lazyAttrsOf package; }; };

      config.rosetta.packages = {
        gh-poi = pkgs.callPackage ../packages/gh-poi.nix { };
        aerospace = pkgs.callPackage ../packages/aerospace.nix { };
      };
    };
}
