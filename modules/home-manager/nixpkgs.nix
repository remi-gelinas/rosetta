{ fenix, ... }:
{
  nixpkgs.overlays = [ fenix.overlays.default ];
}
