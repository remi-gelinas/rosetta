{
  lib,
  config,
  options,
  ...
}:
with lib;
{
  options.flake = with types; {
    darwinConfigurations = mkOption { type = attrsOf unspecified; };
    commonModules = mkOption { type = attrsOf unspecified; };
    homeManagerModules = mkOption { type = attrsOf unspecified; };
    darwinModules = mkOption { type = attrsOf unspecified; };
  };

  config.flake =
    let
      darwinSystems = builtins.mapAttrs (
        _: config: config.finalSystem
      ) config.rosetta.darwinConfigurations;
    in
    {
      inherit (config.rosetta) commonModules homeManagerModules darwinModules;

      darwinConfigurations = darwinSystems;
      githubActions = config.rosetta.githubActionsMatrix;
    };

  config.perSystem =
    { config, ... }:
    {
      config.packages = config.rosetta.packages;
    };
}
