{
  perSystem =
    { lib, pkgs, ... }:
    with lib;
    {
      options.rosetta.packages =
        with types;
        mkOption { type = submodule { freeformType = attrsOf package; }; };

      config.rosetta.packages = {
        gh-poi = pkgs.callPackage ../packages/gh-poi/package.nix { };
        aerospace = pkgs.callPackage ../packages/aerospace/package.nix { };
      };
    };
}
