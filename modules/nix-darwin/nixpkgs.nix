{ fenix, nixpkgs-firefox-darwin, ... }:
{ config, ... }:
{
  _file = ./nixpkgs.nix;

  imports = [ ../common/nixpkgs-config.nix ];

  nixpkgs.overlays = [
    fenix.overlays.default
    nixpkgs-firefox-darwin.overlay
  ];

  nixpkgs.config = config.rosetta.nixpkgsConfig;
}
