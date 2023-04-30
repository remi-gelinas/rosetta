{
  self,
  lib,
  withSystem,
  ...
}: let
  inherit (lib) attrValues makeOverridable;
in {
  flake.darwinConfigurations.M1 = withSystem "aarch64-darwin" ({
    config,
    pkgs,
    ...
  }:
    makeOverridable config.flake.lib.mkDarwinSystem {
      modules = attrValues self.darwinModules;
      homeModules = attrValues self.homeManagerModules ++ [pkgs.nur-no-pkgs.repos.rycee.hmModules.emacs-init];
    });
}
