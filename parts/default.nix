{
  importApply,
  withSystem,
  config,
}:
{
  devShells = ./devshells.nix;
  packages = ./packages.nix;
  darwinModules = ./modules/nix-darwin.nix;
  homeManagerModules = importApply ./modules/home-manager.nix { inherit withSystem config; };
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
