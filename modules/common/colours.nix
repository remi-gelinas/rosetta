{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  _file = ./colours.nix;

  options.rosetta.colours =
    let
      PaletteType = types.submodule { freeformType = types.lazyAttrsOf types.str; };
    in
    mkOption { type = types.submodule { freeformType = types.lazyAttrsOf PaletteType; }; };
}
