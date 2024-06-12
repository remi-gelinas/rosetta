{
  perSystem =
    { lib, pkgs, ... }:
    with lib;
    {
      options.rosetta.packages =
        with types;
        mkOption { type = submodule { freeformType = lazyAttrsOf package; }; };

      config.rosetta.packages =
        let
          packages = import ../packages;
        in
        {
          gh-poi = pkgs.callPackage packages.gh-poi { };
          aerospace = pkgs.callPackage packages.aerospace { };
        };
    };
}
