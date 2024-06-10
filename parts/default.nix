{
  importApply,
  withSystem,
  inputs,
  config,
}:
let
  rosetta = {
    inherit withSystem inputs config;
  };
in
{
  devShells = ./devshells.nix;
  packages = ./packages.nix;
  darwinModules = importApply ./modules/nix-darwin.nix { inherit rosetta; };
  homeManagerModules = importApply ./modules/home-manager.nix { inherit rosetta; };
  commonModules = ./modules/common.nix;
  darwinConfigurations = ./darwin-configurations.nix;
  githubActions = ./github-actions.nix;
  nixpkgsConfig = ./nixpkgs-config.nix;
  gitHooks = ./git-hooks.nix;
  primaryUser = ./primary-user;
  colours = ./colours.nix;
  formatter = ./formatter.nix;
  outputs = ./outputs.nix;
}
