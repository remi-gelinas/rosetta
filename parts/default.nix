{
  devShells = ./devshells.nix;
  packages = ./packages.nix;
  darwinModules = ./nix-darwin-modules.nix;
  homeManagerModules = ./home-manager-modules.nix;
  nixpkgsConfig = ./nixpkgs-config.nix;
  darwinConfigurations = ./darwin-configurations.nix;
  preCommitHooks = ./pre-commit-hooks.nix;
}
