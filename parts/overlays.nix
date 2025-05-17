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

        # Until Lix 2.92 is promoted to stable in nixpkgs
        inherit (nixpkgs-master.legacyPackages.${system}.lixPackageSets.lix_2_92) lix;

        master = nixpkgs-master.legacyPackages.${system};
      }
    )
    (_: prev: import ../pkgs/top-level/all-packages.nix { pkgs = prev; })
    fenix.overlays.default
    fonts.overlays.default
    lix-module.overlays.lixFromNixpkgs
  ];
}
