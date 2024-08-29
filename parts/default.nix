{
  packages = ./packages.nix;
  gitHooks = ./git-hooks.nix;
  formatter = ./formatter.nix;
  overlays = ./overlays.nix;
  devShells = ./devshells.nix;
  darwinConfigurations = ./darwin-configurations.nix;
  githubActions = ./github-actions.nix;
  darwinModules = ./modules/nix-darwin.nix;
  homeManagerModules = ./modules/home-manager.nix;
}
