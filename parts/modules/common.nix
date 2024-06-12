{ lib, ... }:
with lib;
{
  options.rosetta.commonModules =
    with types;
    mkOption { type = submodule { freeformType = attrsOf unspecified; }; };

  config.rosetta.commonModules = import ../../modules/common;
}
