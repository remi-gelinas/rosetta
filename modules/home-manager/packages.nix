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
    jq
    kubectl
    kubernetes-helm
    luajitPackages.luarocks
    php83
    php83Packages.composer
    ripgrep
    wget
    nixd
    neovim
    warp-terminal
  ];
}
