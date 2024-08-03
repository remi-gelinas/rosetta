{ local }:
{ lib, config, ... }@args:
with lib;
let
  inherit (local.inputs) nix-darwin;

  cfg = config.rosetta.darwinConfigurations;
in
{
  _file = "./darwin-configurations.nix";

  options.rosetta.darwinConfigurations =
    with types;
    mkOption {
      type = uniq (submodule {
        freeformType = attrsOf (
          submodule (
            { config, ... }:
            {
              options = {
                system = mkOption {
                  type = enum [
                    "aarch64-darwin"
                    "x86_64-darwin"
                  ];
                };

                modules = mkOption {
                  type = listOf deferredModule;
                  default = [ ];
                };

                homeModules = mkOption {
                  type = listOf deferredModule;
                  default = [ ];
                };

                finalSystem = mkOption {
                  # TODO: Figure out the correct type for a Darwin system, if it exists
                  type = unspecified;
                  readOnly = true;
                };
              };

              config.finalSystem = nix-darwin.lib.darwinSystem { inherit (config) system modules; };
            }
          )
        );
      });

      default = (import ../systems args).darwin;
    };

  config = {
    flake.checks = foldAttrs mergeAttrs { } (
      mapAttrsToList (name: system: {
        ${system.finalSystem.system.system} = {
          "darwin-system-${name}" = system.finalSystem.system;
        };
      }) cfg
    );
  };
}
