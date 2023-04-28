self: super: {
  kubectl-argo-rollouts = super.callPackage ../pkgs/kubectl-argo-rollouts {};
  gh-poi = super.callPackage ../pkgs/gh-poi {};
}
