{ lib, config, ... }:
with lib;
{
  options.flake = with types; {
    darwinConfigurations = mkOption { type = lazyAttrsOf unspecified; };
    commonModules = mkOption { type = lazyAttrsOf unspecified; };
    homeManagerModules = mkOption { type = lazyAttrsOf unspecified; };
    darwinModules = mkOption { type = lazyAttrsOf unspecified; };
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
