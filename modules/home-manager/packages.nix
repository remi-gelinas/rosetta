{ withSystem
, nixpkgs-unstable
,
}: { pkgs
   , config
   , ...
   }: {
  programs = {
    bat = { enable = true; };

    direnv = {
      enable = true;
      nix-direnv = { enable = true; };
    };
  };

  home.packages = with pkgs; let
    unstable = import nixpkgs-unstable {
      inherit (pkgs) system;
      config = config.nixpkgsConfig;
    };

    nixd = withSystem pkgs.system ({ inputs', ... }: inputs'.nixd.packages.nixd);
  in
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
    terraform
    unstable.nix-output-monitor
    expect
    packer
    nixd
    nurl
    nvd
  ];
}
