{ lib, inputs, ... }:
let
  inherit (inputs)
    lix-module
    nixpkgs-master
    fenix
    fonts
    nixd
    zls
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
        inherit (nixd.packages.${system}) nixd;
        inherit (zls.packages.${system}) zls;
        inherit (nixpkgs-master.legacyPackages.${system}) atuin zig lix;
      }
    )
    (_: prev: import ../pkgs/top-level/all-packages.nix { pkgs = prev; })
    fenix.overlays.default
    fonts.overlays.default
    lix-module.overlays.lixFromNixpkgs
  ];
}
