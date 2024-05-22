{ fenix, nixpkgs-firefox-darwin, ... }:
{
  nixpkgs.overlays = [
    fenix.overlays.default
    nixpkgs-firefox-darwin.overlay
  ];
}
