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
}
// importApplyModules {
  devShells = ./devshells.nix;
  darwinConfigurations = ./darwin-configurations.nix;
  githubActions = ./github-actions.nix;
  darwinModules = ./modules/nix-darwin.nix;
  homeManagerModules = ./modules/home-manager.nix;
}
