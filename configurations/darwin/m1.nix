{
  self,
  lib,
  withSystem,
  inputs,
  config,
  ...
}: let
  inherit (lib) attrValues makeOverridable;
in {
  flake.darwinConfigurations.M1 = withSystem "aarch64-darwin" ({
      pkgs,
      system,
      self',
      ...
    } @ systemLevel: let
      nur-no-pkgs = import inputs.nur {
        nurpkgs = pkgs;
        pkgs = throw "nixpkgs eval";
      };
    in
      makeOverridable config.lib.mkDarwinSystem {
        inherit system;
        inherit pkgs;
        modules =
          attrValues self.darwinModules
          ++ [
            {
              config._module.args = {
                flakePackages = self'.packages;
                systemConfig = systemLevel.config;
              };
            }
            {
              home-manager.extraSpecialArgs = {
                flakePackages = self'.packages;
                systemConfig = systemLevel.config;
              };
            }
          ];
        homeModules = attrValues self.homeManagerModules ++ [nur-no-pkgs.repos.rycee.hmModules.emacs-init];
      });

  flake.darwinConfigurations.M1-ci = withSystem "x86_64-darwin" ({system, ...}:
    config.flake.darwinConfigurations.M1.override {
      inherit system;
    });
}
