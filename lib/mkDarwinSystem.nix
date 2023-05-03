{
  inputs,
  lib,
  config,
  ...
} @ topLevel: let
  inherit (lib) attrsets;
in {
  perSystem = {
    pkgs,
    self',
    ...
  } @ systemLevel: {
    lib = let
      userCfg = config.remi-nix.primaryUser;
    in
      attrsets.optionalAttrs (builtins.elem systemLevel.system ["x86_64-darwin" "aarch64-darwin"]) {
        mkDarwinSystem = {
          system ? systemLevel.system,
          username ? userCfg.username,
          fullName ? userCfg.fullName,
          email ? userCfg.email,
          nixConfigDirectory ? userCfg.nixConfigDirectory,
          modules ? [],
          extraModules ? [],
          homeModules ? [],
          extraHomeModules ? [],
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
                    flakePackages = self'.packages;
                    flakeConfig = topLevel.config;
                    systemConfig = systemLevel.config;
                  };
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
                    extraSpecialArgs = {
                      flakePackages = self'.packages;
                      flakeConfig = topLevel.config;
                      systemConfig = systemLevel.config;
                    };
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
  };
}
