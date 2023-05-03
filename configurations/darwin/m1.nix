{
  self,
  lib,
  withSystem,
  inputs,
  config,
  ...
}: let
  inherit (lib) singleton attrValues makeOverridable;
in {
  flake = {
    darwinConfigurations.M1 = withSystem "aarch64-darwin" ({
        pkgs,
        system,
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

          extraArgs = {
            flakePackages = systemLevel.config.packages;
            flakeConfig = config;
            systemConfig = systemLevel.config;
          };

          modules = attrValues self.darwinModules;
          homeModules = attrValues self.homeManagerModules ++ [nur-no-pkgs.repos.rycee.hmModules.emacs-init];
        });

    darwinConfigurations.M1-ci = withSystem "x86_64-darwin" (
      {system, ...}:
        self.darwinConfigurations.M1.override {
          inherit system;

          username = "runner";
          nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
          extraModules = singleton {homebrew.enable = lib.mkForce false;};
        }
    );
  };
}
