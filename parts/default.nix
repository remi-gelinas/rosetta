{
  packages = ./packages.nix;
  gitHooks = ./git-hooks.nix;
  formatter = ./formatter.nix;
  overlays = ./overlays.nix;
  devShells = ./devshells.nix;
  darwinConfigurations = ./darwin-configurations.nix;
  nixosConfigurations = ./nixos-configurations.nix;
  homeManagerConfigurations = ./home-manager-configurations.nix;
  githubActions = ./github-actions.nix;
}
