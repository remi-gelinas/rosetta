{
  self,
  inputs,
  config,
  lib,
  withSystem,
  ...
}: let
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

      config = let
        withSystemArgs = f: withSystem config.system f;
      in {
        finalModules =
          [
            {
              config._module.args = {
                inherit withSystemArgs;
              };
            }
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit withSystemArgs;
                };
                sharedModules = builtins.attrValues self.homeManagerModules ++ config.homeModules;
              };
            }
            inputs.home-manager.darwinModules.home-manager
            (_: let
              user = config.primaryUser;
            in {
              users.primaryUser = user;
              users.users.${user.username}.home = "/Users/${user.username}";
              nix.nixPath.nixpkgs = "${inputs.nixpkgs-stable}";
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

        finalSystem =
          withSystemArgs
          ({pkgs, ...}:
            inputs.darwin.lib.darwinSystem {
              inherit (config) system;
              inherit pkgs;

              modules = config.finalModules;
            });
      };
    }));
  };

  config.flake.darwinConfigurations = configs;
}
