{
  outputs = {
    devShells = ./devshells.nix;
    legacyPackages = ./legacy-packages.nix;
    nixosModules = ./nixos-modules.nix;
    darwinModules = ./nix-darwin-modules.nix;
    homeManagerModules = ./home-manager-modules.nix;
    commonModules = ./common-modules.nix;
    darwinConfigurations = ./darwin-configurations.nix;
    nixosConfigurations = ./nixos-configurations.nix;
    githubActions = ./github-actions.nix;
    sources = ./sources.nix;
  };

  exports = {
    nixpkgsConfig = ./nixpkgs-config.nix;
    preCommitHooks = ./pre-commit-hooks.nix;
    primaryUser = ./primary-user;
    colors = ./colors.nix;
    emacs = ./emacs;
  };
}
