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
    flatten
    ;
  inherit (flake-parts-lib) mkSubmoduleOptions;

  cfg = config.flake.homeManagerConfigurations;
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

  config.flake.checks = lib.pipe cfg [
    (mapAttrsToList (
      system: configs:
      mapAttrsToList (name: config: {
        ${system} = {
          "home-manager-${name}" = config.activationPackage;
        };
      }) configs
    ))
    flatten
    (foldAttrs recursiveUpdate { })
  ];
}
