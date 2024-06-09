{
  nixd,
  neovim,
  nixpkgs-master,
  ...
}:
{ pkgs, ... }:
let
  pkgsMasterUnfree = import nixpkgs-master {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  _file = ./packages.nix;

  home.packages = with pkgs; [
    coreutils
    dive
    doggo
    fd
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    go
    jq
    kubectl
    kubernetes-helm
    luajitPackages.luarocks
    neovim.packages.${system}.neovim
    nixd.packages.${system}.nixd
    nodejs
    php83
    php83Packages.composer
    pkgsMasterUnfree.warp-terminal
    ripgrep
    wget
  ];
}
