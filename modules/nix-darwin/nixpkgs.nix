{ config, ... }:
let
  inherit (config.rosetta.inputs) fenix nixpkgs-firefox-darwin;
in
{
  nixpkgs.overlays = [
    fenix.overlays.default
    nixpkgs-firefox-darwin.overlay
  ];
}
