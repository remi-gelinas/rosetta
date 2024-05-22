{
  _file = ./packages.nix;

  perSystem =
    { lib, pkgs, ... }:
    let
      inherit (lib) mkOption types;
    in
    {
      options.rosetta.packages = mkOption { type = types.submodule { freeformType = types.package; }; };

      config.rosetta.packages =
        let
          packages = import ../packages;
        in
        {
          gh-poi = pkgs.callPackage packages.gh-poi { };
        };
    };
}
