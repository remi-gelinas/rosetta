{ lib, ... }:
with lib;
{
  options.rosetta.colours =
    with types;
    let
      PaletteType = submodule { freeformType = lazyAttrsOf str; };
    in
    mkOption { type = submodule { freeformType = lazyAttrsOf PaletteType; }; };
}
