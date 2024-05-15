{ lib, ... }:
let
  inherit (lib) mkOption types;

  PaletteType = types.attrsOf types.str;
in
{
  _file = ./colors.nix;

  options.colors = mkOption { type = types.attrsOf PaletteType; };
}
