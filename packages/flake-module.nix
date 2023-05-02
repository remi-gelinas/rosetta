{
  self,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./pragmata-pro/flake-module.nix
    ./gh-poi/flake-module.nix
    ./kubectl-argo-rollouts/flake-module.nix
  ];
}
