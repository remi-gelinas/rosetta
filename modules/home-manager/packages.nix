{ withSystem
, ...
}: { pkgs
   , ...
   }: {
  home.packages =
    let
      nixd = withSystem pkgs.system ({ inputs', ... }: inputs'.nixd.packages.nixd);
      nom = withSystem pkgs.system ({ inputs', ... }: inputs'.nixpkgs-unstable.legacyPackages.nix-output-monitor);
    in
    with pkgs; [
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
      expect
      packer
      nurl
      nvd
    ] ++ [
      nixd
      nom
    ];
}
