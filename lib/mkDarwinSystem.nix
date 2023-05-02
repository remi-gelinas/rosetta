{
  inputs,
  lib,
  ...
}: let
  inherit (lib) attrsets;
in {
  perSystem = {
    pkgs,
    config,
    system,
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
          inherit pkgs;

          modules =
            modules
            ++ extraModules
            ++ [
              inputs.home-manager.darwinModules.home-manager
              (_: let
                user = config.primary-user;
              in {
                users.primaryUser = {
                  inherit (user) username fullName email nixConfigDirectory;
                };

                nix.nixPath.nixpkgs = "${inputs.nixpkgs-stable}";

                users.users.${user.username}.home = "/Users/${user.username}";

                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${user.username} = {
                    imports = homeModules ++ extraHomeModules;
                    home = {
                      stateVersion = config.homeStateVersion;
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
