{
  inputs,
  lib,
  config,
  ...
} @ topLevel: {
  lib.mkDarwinSystem = {
    system,
    modules ? [],
    extraModules ? [],
    homeModules ? [],
    extraHomeModules ? [],
    pkgs,
  }:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      inherit pkgs;
      inherit inputs;

      modules =
        modules
        ++ extraModules
        ++ [
          {
            config._module.args = {
              flakeConfig = topLevel.config;
            };
          }
        ]
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
                flakeConfig = topLevel.config;
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
}
