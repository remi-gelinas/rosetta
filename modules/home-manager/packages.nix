{nixpkgs-unstable}: {
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
  ];
}
