{ lib, ... }:
with lib;
{
  options.rosetta.colours =
    with types;
    let
      PaletteType = submodule { freeformType = attrsOf str; };
    in
    mkOption { type = submodule { freeformType = attrsOf PaletteType; }; };
}
