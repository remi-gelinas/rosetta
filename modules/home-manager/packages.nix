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

    tart = withSystem pkgs.system ({config, ...}: config.legacyPackages.tart);
    nixd = withSystem pkgs.system ({inputs', ...}: inputs'.nixd.packages.nixd);
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
      alejandra
      kubernetes-helm
      kubectl
      terraform
      unstable.nix-output-monitor
      expect
      packer
      nixd
    ]
    ++ pkgs.lib.optional (pkgs.system == "aarch64-darwin") tart;
}
