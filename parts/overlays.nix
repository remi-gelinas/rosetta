{ lib, inputs, ... }:
let
  inherit (inputs)
    lix-module
    nixpkgs-master
    nixpkgs-firefox-darwin
    fenix
    fonts
    nixd
    neovim
    zls
    firefox-addons
    ;
in
{
  flake.overlays.default = lib.composeManyExtensions [
    (
      _: prev:
      let
        inherit (prev) system;
      in
      {
        inherit (neovim.packages.${system}) neovim;
        inherit (nixd.packages.${system}) nixd;
        inherit (zls.packages.${system}) zls;
        inherit (nixpkgs-master.legacyPackages.${system}) atuin zig lix;

        firefox-addons = firefox-addons.packages.${system};
      }
    )
    (_: prev: import ../pkgs/top-level/all-packages.nix { pkgs = prev; })
    fenix.overlays.default
    nixpkgs-firefox-darwin.overlay
    fonts.overlays.default
    lix-module.overlays.lixFromNixpkgs
  ];
}
