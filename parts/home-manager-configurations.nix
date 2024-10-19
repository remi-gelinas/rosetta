{ lib, flake-parts-lib, ... }:
let
  inherit (lib) mkOption types;
  inherit (flake-parts-lib) mkSubmoduleOptions;
in
{
  imports = [ ../users ];

  options.flake = mkSubmoduleOptions {
    homeManagerConfigurations = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
      description = '''';
    };
  };
}
