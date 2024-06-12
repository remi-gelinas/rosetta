{
  lib,
  inputs,
  options,
  config,
  ...
}@args:
with lib;
let
  cfg = config.rosetta.darwinConfigurations;
in
{
  options.rosetta.darwinConfigurations =
    with types;
    mkOption {
      type = uniq (submodule {
        freeformType = lazyAttrsOf (
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
                  type = listOf unspecified;
                  default = [ ];
                };

                homeModules = mkOption {
                  type = listOf unspecified;
                  default = [ ];
                };

                finalModules = mkOption {
                  type = listOf unspecified;
                  readOnly = true;
                };

                finalSystem = mkOption {
                  type = unspecified;
                  readOnly = true;
                };
              };

              config = {
                finalModules = [
                  inputs.home-manager.darwinModules.home-manager
                  inputs.lix-module.nixosModules.default
                  {
                    home-manager = {
                      sharedModules = config.homeModules;
                    };
                  }
                  (
                    _:
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

                finalSystem = inputs.nix-darwin.lib.darwinSystem {
                  inherit (config) system;
                  modules = config.finalModules;
                };
              };
            }
          )
        );
      });
    };

  config = {
    rosetta.darwinConfigurations = mkDefault (import ../systems args).darwin;

    flake.checks = foldAttrs mergeAttrs { } (
      mapAttrsToList (name: system: {
        ${system.finalSystem.system.system} = {
          "darwin-system-${name}" = system.finalSystem.system;
        };
      }) cfg
    );
  };
}
