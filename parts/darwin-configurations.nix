{ rosetta }:
{
  lib,
  options,
  config,
  ...
}@args:
with lib;
let
  inherit (rosetta.inputs) nix-darwin;

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

                homeStateVersion = mkOption {
                  type = str;
                  default = "23.05";
                };

                inherit (options.rosetta) primaryUser;

                modules = mkOption {
                  type = listOf deferredModule;
                  default = [ ];
                };

                homeModules = mkOption {
                  type = listOf deferredModule;
                  default = [ ];
                };

                finalModules = mkOption {
                  type = listOf deferredModule;
                  readOnly = true;
                };

                finalSystem = mkOption {
                  # TODO: Figure out the correct type for a Darwin system, if it exists
                  type = unspecified;
                  readOnly = true;
                };
              };

              config = {
                finalModules = [
                  {
                    home-manager = {
                      sharedModules = config.homeModules;
                    };
                  }
                  (
                    let
                      user = config.primaryUser;
                    in
                    {
                      users.users.${user.username}.home = "/Users/${user.username}";

                      home-manager = {
                        useGlobalPkgs = true;

                        users.${user.username} = {
                          home = {
                            stateVersion = config.homeStateVersion;
                          };

                          inherit (user) email name gpg;
                        };
                      };
                    }
                  )
                ] ++ config.modules;

                finalSystem = nix-darwin.lib.darwinSystem {
                  inherit (config) system;
                  modules = config.finalModules;
                };
              };
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
