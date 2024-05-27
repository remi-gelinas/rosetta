{ nixd, neovim, ... }:
{ pkgs, ... }:
{
  _file = ./packages.nix;

  home.packages = with pkgs; [
    wget
    cachix
    coreutils
    nodejs
    jq
    ripgrep
    fd
    git-filter-repo
    kubernetes-helm
    kubectl
    expect
    nurl
    nvd
    nix-output-monitor
    # warp-terminal
    go
    luajitPackages.luarocks
    php83
    php83Packages.composer
    nixd.packages.${pkgs.system}.nixd
    neovim.packages.${system}.neovim
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
  ];
}
