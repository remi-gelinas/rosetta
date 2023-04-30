{
  self,
  inputs,
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  config = {
    systems = ["x86_64-darwin" "aarch64-darwin"];

    perSystem = {
      config,
      pkgs,
      system,
      ...
    }: {
      flake.lib.mkDarwinSystem = {
        modules ? [],
        extraModules ? [],
        homeModules ? [],
        extraHomeModules ? [],
      }:
        inputs.darwin.lib.darwinSystem {
          inherit system;

          modules =
            modules
            ++ extraModules
            ++ [
              inputs.home-manager.darwinModules.home-manager
              (_: let
                user = config.primary-user;
              in {
                users.primaryUser = user;

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
