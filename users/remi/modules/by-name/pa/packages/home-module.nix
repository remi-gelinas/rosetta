{ pkgs, lib, ... }:
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
  home.packages =
    with pkgs;
    [
      asciinema
      bun
      coreutils
      dive
      doggo
      fastfetch
      fd
      fenixRust
      go
      jq
      kubectl
      kubernetes-helm
      luajitPackages.luarocks
      magic-wormhole-rs
      nix-inspect
      nixd
      nixfmt-rfc-style
      ripgrep
      wget
      zig
      foundry
    ]
    ++ (lib.optionals pkgs.stdenv.isLinux [ ghostty ]);
}
