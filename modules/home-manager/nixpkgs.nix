{ fenix, ... }:
{
  _file = ./nixpkgs.nix;

  imports = [ ../common/nixpkgs-config.nix ];

  nixpkgs.overlays = [ fenix.overlays.default ];
}
