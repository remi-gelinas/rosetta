{
  lib,
  flake-parts-lib,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mapAttrsToList
    foldAttrs
    recursiveUpdate
    ;
  inherit (flake-parts-lib) mkSubmoduleOptions;

  cfg = config.flake.homeConfigurations;
in
{
  imports = [ ../users ];

  options.flake = mkSubmoduleOptions {
    homeConfigurations = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
      description = '''';
    };
  };

  config.flake.checks =
    cfg
    |> (mapAttrsToList (
      name: config: {
        ${config.pkgs.system} = {
          "home-manager-${name}" = config.activationPackage;
        };
      }
    ))
    |> (foldAttrs recursiveUpdate { });
}
