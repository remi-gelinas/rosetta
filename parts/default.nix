{
  outputs = {
    devShells = ./devshells.nix;
    legacyPackages = ./legacy-packages.nix;
    darwinModules = ./nix-darwin-modules.nix;
    homeManagerModules = ./home-manager-modules.nix;
    commonModules = ./common-modules.nix;
    darwinConfigurations = ./darwin-configurations.nix;
  };

  exports = {
    nixpkgsConfig = ./nixpkgs-config.nix;
    preCommitHooks = ./pre-commit-hooks.nix;
    primaryUser = ./primary-user;
    colors = ./colors.nix;
    emacs = ./emacs;
  };
}
