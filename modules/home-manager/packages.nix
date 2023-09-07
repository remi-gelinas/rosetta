{
  withSystem,
  nixpkgs-unstable,
}: {
  pkgs,
  config,
  ...
}: {
  programs = {
    bat = {enable = true;};

    direnv = {
      enable = true;
      nix-direnv = {enable = true;};
    };
  };

  home.packages = with pkgs; let
    unstable = import nixpkgs-unstable {
      inherit (pkgs) system;
      config = config.nixpkgsConfig;
    };

    nixd = withSystem pkgs.system ({
        inputs',
        pkgs,
        ...
      }:
      # TODO: remove override when merged: https://github.com/nix-community/nixd/pull/226
        inputs'.nixd.packages.nixd.overrideAttrs (prev: {
          doCheck = false;
          buildInputs = prev.buildInputs ++ [pkgs.lit];
        }));
  in [
    cachix
    coreutils
    nodejs
    nodePackages.node2nix
    jq
    git-crypt
    ripgrep
    fd
    git-filter-repo
    alejandra
    kubernetes-helm
    kubectl
    terraform
    unstable.nix-output-monitor
    expect
    packer
    nixd
  ];
}
