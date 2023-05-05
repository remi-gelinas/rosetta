{
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (lib) mkOption types;
  inherit (flake-parts-lib) mkSubmoduleOptions;
in {
  imports = [
    ./m1.nix
  ];

  options = {
    flake.darwinConfigurations = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = {};
    };
  };
}
