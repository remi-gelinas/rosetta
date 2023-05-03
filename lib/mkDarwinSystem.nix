{
  inputs,
  lib,
  config,
  ...
} @ topLevel: {
  lib = let
    userCfg = config.remi-nix.primaryUser;
  in {
    mkDarwinSystem = {
      system,
      username ? userCfg.username,
      fullName ? userCfg.fullName,
      email ? userCfg.email,
      nixConfigDirectory ? userCfg.nixConfigDirectory,
      pkgs,
      modules ? [],
      extraModules ? [],
      homeModules ? [],
      extraHomeModules ? [],
      extraArgs ? {},
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
              config._module.args = extraArgs;
            }
          ]
          ++ [
            inputs.home-manager.darwinModules.home-manager
            (_: let
              user = {
                inherit username fullName email nixConfigDirectory;
              };
            in {
              users.primaryUser = user;

              nix.nixPath.nixpkgs = "${inputs.nixpkgs-stable}";

              users.users.${username}.home = "/Users/${username}";

              home-manager = {
                extraSpecialArgs = extraArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = {
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
}
