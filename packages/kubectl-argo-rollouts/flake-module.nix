_: {
  perSystem = {pkgs, ...}: {
    packages.kubectl-argo-rollouts = pkgs.callPackage ./package.nix {};
  };
}
