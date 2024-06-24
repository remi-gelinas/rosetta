{
  lib,
  config,
  options,
  ...
}:
with lib;
{
  options.flake = with types; {
    inherit (options.rosetta) primaryUser;

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
      darwinConfigurations = darwinSystems;
      githubActions = config.rosetta.githubActionsMatrix;
      inherit (config.rosetta)
        primaryUser
        commonModules
        homeManagerModules
        darwinModules
        ;
    };

  config.perSystem =
    { config, ... }:
    {
      config.packages = config.rosetta.packages;
    };
}
