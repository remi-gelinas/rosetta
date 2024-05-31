{ lib, config, ... }:
let
  inherit (lib) mkOption types;
in
{
  _file = ./outputs.nix;

  options.flake = {
    darwinConfigurations = mkOption { type = types.lazyAttrsOf types.unspecified; };
    commonModules = mkOption { type = types.submodule { freeformType = types.submodule { }; }; };
    homeManagerModules = mkOption { type = types.submodule { freeformType = types.submodule { }; }; };
    darwinModules = mkOption { type = types.submodule { freeformType = types.submodule { }; }; };
  };

  config.flake =
    let
      darwinSystems = builtins.mapAttrs (
        _: config: config.finalSystem
      ) config.rosetta.darwinConfigurations;
    in
    {
      darwinConfigurations = darwinSystems;
      githubActions = config.rosetta.githubActionsMatrix;
      inherit (config.rosetta) commonModules homeManagerModules darwinModules;
    };

  config.perSystem =
    { config, ... }:
    {
      config.packages = config.rosetta.packages;
    };
}
