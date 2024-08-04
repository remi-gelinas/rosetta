{
  perSystem =
    { lib, pkgs, ... }:
    with lib;
    {
      options.rosetta.packages =
        with types;
        mkOption { type = submodule { freeformType = attrsOf package; }; };
      config.rosetta.packages = import ../packages/top-level/all-packages.nix { inherit pkgs; };
    };
}
