{
  lib,
  inputs,
  options,
  config,
  ...
}@args:
let
  inherit (lib) mkOption types;

  cfg = config.rosetta.darwinConfigurations;
in
{
  options.rosetta.darwinConfigurations = mkOption {
    type = types.uniq (
      types.submodule {
        freeformType = types.lazyAttrsOf (
          types.submodule (
            { config, ... }:
            {
              options = {
                system = mkOption {
                  type = types.enum [
                    "aarch64-darwin"
                    "x86_64-darwin"
                  ];
                };

                homeStateVersion = mkOption {
                  type = types.str;
                  default = "23.05";
                };

                inherit (options.rosetta) primaryUser;

                modules = mkOption {
                  type = types.listOf types.unspecified;
                  default = [ ];
                };

                homeModules = mkOption {
                  type = types.listOf types.unspecified;
                  default = [ ];
                };

                finalModules = lib.mkOption {
                  type = lib.types.listOf lib.types.unspecified;
                  readOnly = true;
                };

                finalSystem = lib.mkOption {
                  type = lib.types.unspecified;
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
      }
    );
  };

  config = {
    rosetta.darwinConfigurations = lib.mkDefault (import ../systems args).darwin;

    flake.checks = lib.foldAttrs lib.mergeAttrs { } (
      lib.mapAttrsToList (name: system: {
        ${system.finalSystem.system.system} = {
          "darwin-system-${name}" = system.finalSystem.system;
        };
      }) cfg
    );
  };
}
