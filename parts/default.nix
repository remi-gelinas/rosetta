{
  outputs = {
    devShells = ./devshells.nix;
    packages = ./packages.nix;
    darwinModules = ./nix-darwin-modules.nix;
    homeManagerModules = ./home-manager-modules.nix;
    darwinConfigurations = ./darwin-configurations.nix;
  };

  exports = {
    nixpkgsConfig = ./nixpkgs-config.nix;
    preCommitHooks = ./pre-commit-hooks.nix;
    primaryUser = ./primary-user;
    colors = ./colors.nix;
  };
}
