{ local }:
{ pkgs, ... }:
let
  inherit (local.inputs)
    fenix
    firefox-addons
    fonts
    neovim
    nixd
    nixpkgs-firefox-darwin
    nixpkgs-master
    ;
in
{
  nixpkgs.overlays = [
    fenix.overlays.default
    nixpkgs-firefox-darwin.overlay
    fonts.overlays.default
    (_: _: {
      inherit (neovim.packages.${pkgs.system}) neovim;
      inherit (nixd.packages.${pkgs.system}) nixd;
      inherit (local.config.flake.packages.${pkgs.system}) aerospace gh-poi;
      inherit (nixpkgs-master.legacyPackages.${pkgs.system}) atuin;

      firefox-addons = firefox-addons.packages.${pkgs.system};
    })
  ];
}
