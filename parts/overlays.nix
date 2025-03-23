{ lib, inputs, ... }:
let
  inherit (inputs)
    lix-module
    nixpkgs-master
    fenix
    fonts
    ghostty
    nixd
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
        inherit (ghostty.packages.${system}) ghostty;
        inherit (nixd.packages.${system}) nixd;
        inherit (nixpkgs-master.legacyPackages.${system}) neovim-unwrapped;

        master = nixpkgs-master.legacyPackages.${system};
      }
    )
    (_: prev: import ../pkgs/top-level/all-packages.nix { pkgs = prev; })
    fenix.overlays.default
    fonts.overlays.default
    lix-module.overlays.default
  ];
}
