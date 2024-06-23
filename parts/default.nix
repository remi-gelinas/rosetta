{ lib, importApply, ... }:
with lib;
let
  importApplyModules = mapAttrs (_: importApply);
in
{
  packages = ./packages.nix;
  commonModules = ./modules/common.nix;
  nixpkgsConfig = ./nixpkgs-config.nix;
  gitHooks = ./git-hooks.nix;
  primaryUser = ./primary-user;
  colours = ./colours.nix;
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
