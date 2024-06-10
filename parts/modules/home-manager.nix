{ rosetta }:
{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  _file = ./home-manager.nix;

  options.rosetta.homeManagerModules = mkOption {
    type = types.submodule { freeformType = types.attrsOf types.unspecified; };
  };

  config.rosetta.homeManagerModules = import ../../modules/home-manager rosetta;
}
