{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  _file = ./nixpkgs-config.nix;

  options.nixpkgsConfig = mkOption { type = types.attrsOf types.unspecified; };
}
