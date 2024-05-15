{ nixd, ... }:
{ pkgs, ... }:
{
  _file = ./packages.nix;

  home.packages =
    let
      nixdPkg = nixd.packages.${pkgs.system}.nixd;
    in
    with pkgs;
    [
      cachix
      coreutils
      nodejs
      nodePackages.node2nix
      jq
      git-crypt
      ripgrep
      fd
      git-filter-repo
      kubernetes-helm
      kubectl
      expect
      nurl
      nvd
      nix-output-monitor
      warp-terminal
      nixdPkg
    ];
}
