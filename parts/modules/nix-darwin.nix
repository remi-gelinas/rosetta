{ rosetta }:
{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  _file = ./nix-darwin.nix;

  options.rosetta.darwinModules = mkOption {
    type = types.submodule { freeformType = types.attrsOf types.unspecified; };
  };

  config.rosetta.darwinModules = import ../../modules/nix-darwin rosetta;
}
