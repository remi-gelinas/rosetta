{
  pkgs,
  pkgs-master,
  rosetta,
  ...
}:
let
  inherit (rosetta.inputs) nixd neovim;
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
    pkgs-master.warp-terminal
    nodejs
    php83
    php83Packages.composer
    ripgrep
    wget
  ];
}
