{ lib, importApply, ... }:
with lib;
let
  importApplyModules = mapAttrs (_: importApply);
in
{
  packages = ./packages.nix;
  gitHooks = ./git-hooks.nix;
  formatter = ./formatter.nix;
  outputs = ./outputs.nix;
  devShells = ./devshells.nix;
}
// importApplyModules {
  darwinConfigurations = ./darwin-configurations.nix;
  githubActions = ./github-actions.nix;
  darwinModules = ./modules/nix-darwin.nix;
  homeManagerModules = ./modules/home-manager.nix;
}
