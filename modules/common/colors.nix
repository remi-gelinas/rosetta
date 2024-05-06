{ lib, ... }:
let
  inherit (lib) mkOption types;

  PaletteType = types.attrsOf types.str;
in
{
  options.colors = mkOption {
    type = types.attrsOf PaletteType;
  };
}
