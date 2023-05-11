{
  self,
  inputs,
  config,
  lib,
  ...
} @ args: let
  inherit (lib) mkOption types;

  cfg = config.remi-nix.darwinConfigurations;
  configs = builtins.mapAttrs (_: config: config.finalSystem) cfg;
in {
  options.remi-nix.darwinConfigurations = mkOption {
    type = types.attrsOf (types.submodule ({config, ...}: {
      options = {
        system = mkOption {
          type = types.enum ["aarch64-darwin" "x86_64-darwin"];
        };

        homeStateVersion = mkOption {
          type = types.str;
          default = "23.05";
        };

        primaryUser = {
          username = mkOption {
            type = types.str;
          };

          fullName = mkOption {
            type = types.str;
          };

          email = mkOption {
            type = types.str;
          };

          nixConfigDirectory = mkOption {
            type = types.str;
          };

          gpgKey = {
            master = mkOption {
              type = types.str;
            };

            publicKey = mkOption {
              type = types.str;
            };

            subkeys = {
              authentication = mkOption {
                type = types.str;
              };

              encryption = mkOption {
                type = types.str;
              };

              signing = mkOption {
                type = types.str;
              };
            };
          };
        };

        modules = mkOption {
          type = types.listOf types.unspecified;
          default = [];
        };

        homeModules = mkOption {
          type = types.listOf types.unspecified;
          default = [];
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
        finalModules =
          [
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager = {
                sharedModules = builtins.attrValues self.homeManagerModules ++ config.homeModules;
              };
            }
            (_: let
              user = config.primaryUser;
            in {
              users.primaryUser = user;
              users.users.${user.username}.home = "/Users/${user.username}";
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user.username} = {
                  home = {
                    stateVersion = config.homeStateVersion;
                    user-info = user;
                  };
                };
              };
            })
          ]
          ++ config.modules
          ++ builtins.attrValues self.darwinModules;

        finalSystem = inputs.darwin.lib.darwinSystem {
          inherit (config) system;

          modules = config.finalModules;
        };
      };
    }));
  };

  options = {
    flake.darwinConfigurations = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = {};
    };
  };

  config.flake.darwinConfigurations = configs;
  config.remi-nix.darwinConfigurations = (import ../configurations args).darwin;
}
