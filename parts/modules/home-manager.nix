{
  lib,
  flake-parts-lib,
  moduleLocation,
  ...
}:
let
  inherit (lib) types mkOption mapAttrs;
  inherit (flake-parts-lib) mkSubmoduleOptions;
in
{
  options.flake = mkSubmoduleOptions {
    homeManagerModules = mkOption {
      type = types.lazyAttrsOf types.deferredModule;

      default = { };

      apply = mapAttrs (
        k: v: {
          _file = "${toString moduleLocation}#homeManagerModules.${k}";
          imports = [ v ];
        }
      );

      description = ''
        home-manager modules.

        You may use this for reusable pieces of configuration, service modules, etc.
      '';
    };
  };

  config.flake.homeManagerModules =
    (import ../../modules/top-level/all-modules.nix { inherit lib; }).home;
}
