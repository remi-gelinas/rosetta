{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) attrsets;
in {
  perSystem = {
    pkgs,
    system,
    self',
    ...
  }: {
    lib = attrsets.optionalAttrs (builtins.elem system ["x86_64-darwin" "aarch64-darwin"]) {
      mkDarwinSystem = {
        modules ? [],
        extraModules ? [],
        homeModules ? [],
        extraHomeModules ? [],
      }:
        inputs.darwin.lib.darwinSystem {
          inherit system;
          pkgs = pkgs // self'.packages;

          modules =
            modules
            ++ extraModules
            ++ [
              inputs.home-manager.darwinModules.home-manager
              (_: let
                user = {
                  inherit (config.remi-nix.primaryUser) username fullName email nixConfigDirectory;
                };
              in {
                users.primaryUser = user;

                nix.nixPath.nixpkgs = "${inputs.nixpkgs-stable}";

                users.users.${user.username}.home = "/Users/${user.username}";

                home-manager = {
                  extraSpecialArgs = {
                    flakeConfig = config;
                  };
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${user.username} = {
                    imports = homeModules ++ extraHomeModules;
                    home = {
                      stateVersion = config.remi-nix.homeStateVersion;
                      user-info = user;
                    };
                  };
                };
              })
            ];
        };
    };
  };
}
