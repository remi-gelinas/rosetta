{ pkgs, ... }:
let
  fenixRust = pkgs.fenix.complete.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ];
in
{
  home.packages = with pkgs; [
    bun
    coreutils
    dive
    doggo
    fd
    fenixRust
    go
    gitsign
    jq
    kubectl
    kubernetes-helm
    luajitPackages.luarocks
    neovim
    nix-inspect
    nixd
    php83
    php83Packages.composer
    ripgrep
    warp-terminal
    wget
  ];
}
