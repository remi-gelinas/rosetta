{ pkgs, config, ... }:
let
  inherit (config.rosetta.inputs) nixd neovim nixpkgs-master;
in
{
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
    nixpkgs-master.warp-terminal
    nodejs
    php83
    php83Packages.composer
    ripgrep
    wget
  ];
}
