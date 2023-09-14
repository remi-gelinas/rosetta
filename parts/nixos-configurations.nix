{
  config,
  inputs,
  ...
}: {lib, ...}: let
  inherit (lib) mkOption types;

  cfg = config.nixosConfigurations;

  systems = builtins.mapAttrs (_: config: config.finalSystem) cfg;
in {
  options.nixosConfigurations = mkOption {
    type = types.attrsOf (types.submodule ({config, ...}: {
      options = {
        system = mkOption {
          type = types.enum ["aarch64-linux" "x86_64-linux"];
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
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                sharedModules = config.homeModules;
              };
            }
            (_: let
              user = config.primaryUser;
            in {
              users.primaryUser = user;

              users.users.${user.username} = {
                isNormalUser = true;
                extraGroups = ["wheel"];
                home = "/home/${user.username}";
              };

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
          ++ config.modules;

        finalSystem = inputs.nixpkgs-unstable.lib.nixosSystem {
          inherit (config) system;
          modules = config.finalModules;
        };
      };
    }));
  };

  config.nixosConfigurations = import ../systems/nixos {
    inherit config;
    inherit (inputs) hyprland nixpkgs-unstable;
  };

  config.flake.nixosConfigurations = systems;
  config.flake.checks = lib.mkMerge (lib.attrsets.mapAttrsToList (name: sys: {
      ${sys.config.nixpkgs.hostPlatform.system} = {
        ${name} = sys;
      };
    })
    systems);
}
