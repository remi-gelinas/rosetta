{
  self,
  inputs,
  config,
  lib,
  withSystem,
  ...
} @ topLevel: let
  inherit (lib) mkOption types;

  generalCfg = config.remi-nix;
  cfg = generalCfg.darwinConfigurations;

  configs = builtins.mapAttrs (_: config: config.finalSystem) cfg;
in {
  options.remi-nix.darwinConfigurations = mkOption {
    type = types.attrsOf (types.submodule ({config, ...}: {
      options = {
        system = mkOption {
          type = types.enum ["aarch64-darwin" "x86_64-darwin"];
        };

        primaryUser = {
          username = mkOption {
            type = types.str;
            default = generalCfg.primaryUser.username;
          };

          fullName = mkOption {
            type = types.str;
            default = generalCfg.primaryUser.fullName;
          };

          email = mkOption {
            type = types.str;
            default = generalCfg.primaryUser.email;
          };

          nixConfigDirectory = mkOption {
            type = types.str;
            default = generalCfg.primaryUser.nixConfigDirectory;
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
        finalModules = let
          flakeConfig = topLevel.config;
          withSystemArgs = f: withSystem config.system f;
        in
          [
            {
              config._module.args = {
                inherit withSystemArgs flakeConfig;
              };
            }
            {
              home-manager.extraSpecialArgs = {
                inherit withSystemArgs flakeConfig;
              };
            }
            inputs.home-manager.darwinModules.home-manager
            (_: let
              user = {
                inherit (config.primaryUser) username fullName email nixConfigDirectory;
              };
            in {
              users.primaryUser = user;
              users.users.${user.username}.home = "/Users/${user.username}";
              nix.nixPath.nixpkgs = "${inputs.nixpkgs-stable}";
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user.username} = {
                  imports = builtins.attrValues self.homeManagerModules ++ config.homeModules;
                  home = {
                    stateVersion = generalCfg.homeStateVersion;
                    user-info = user;
                  };
                };
              };
            })
          ]
          ++ config.modules
          ++ builtins.attrValues self.darwinModules;

        finalSystem =
          withSystem config.system
          ({pkgs, ...}:
            inputs.darwin.lib.darwinSystem {
              inherit (config) system;
              inherit inputs pkgs;

              modules = config.finalModules;
            });
      };
    }));
  };

  config.flake.darwinConfigurations = configs;
}
