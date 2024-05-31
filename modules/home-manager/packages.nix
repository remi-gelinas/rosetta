{
  nixd,
  neovim,
  nixpkgs-master,
  ...
}:
{ pkgs, ... }:
{
  _file = ./packages.nix;

  home.packages = with pkgs; [
    doggo
    wget
    coreutils
    nodejs
    jq
    ripgrep
    fd
    kubernetes-helm
    kubectl
    go
    luajitPackages.luarocks
    php83
    php83Packages.composer
    nixd.packages.${system}.nixd
    neovim.packages.${system}.neovim
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    nixpkgs-master.legacyPackages.${system}.warp-terminal
  ];
}
