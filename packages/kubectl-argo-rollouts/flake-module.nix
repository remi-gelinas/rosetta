{
  inputs,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.kubectl-argo-rollouts = pkgs.callPackage ./package.nix {};
  };
}
