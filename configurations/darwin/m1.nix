{
  self,
  lib,
  withSystem,
  inputs,
  ...
}: let
  inherit (lib) singleton mkForce attrValues makeOverridable;
in {
  flake.darwinConfigurations = rec {
    M1 = withSystem "aarch64-darwin" ({
      config,
      pkgs,
      ...
    }: let
      nur-no-pkgs = import inputs.nur {
        nurpkgs = pkgs;
        pkgs = throw "nixpkgs eval";
      };
    in
      makeOverridable config.lib.mkDarwinSystem {
        modules = attrValues self.darwinModules;
        homeModules = attrValues self.homeManagerModules ++ [nur-no-pkgs.repos.rycee.hmModules.emacs-init];
      });

    M1-ci = M1.override {
      extraModules = singleton {homebrew.enable = mkForce false;};
    };
  };
}
