{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  _file = ./common.nix;

  options.rosetta.commonModules = mkOption {
    type = types.submodule { freeformType = types.attrsOf types.unspecified; };
  };

  config.rosetta.commonModules = import ../../modules/common;
}
