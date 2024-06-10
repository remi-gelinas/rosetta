{ config, rosetta, ... }:
let
  inherit (rosetta.inputs) fenix nixpkgs-firefox-darwin;
in
{
  imports = [ ../common/nixpkgs-config.nix ];

  nixpkgs.overlays = [
    fenix.overlays.default
    nixpkgs-firefox-darwin.overlay
  ];

  nixpkgs.config = rosetta.config.rosetta.nixpkgsConfig;
}
