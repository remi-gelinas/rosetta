{
  perSystem = {pkgs, ...}: {
    overlayAttrs = {
      kubectl-argo-rollouts = pkgs.callPackage ../pkgs/kubectl-argo-rollouts {};
      gh-poi = pkgs.callPackage ../pkgs/gh-poi {};
    };
  };
}
