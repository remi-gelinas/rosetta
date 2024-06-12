{ rosetta }:
{ lib, ... }:
with lib;
{
  _file = ./home-manager.nix;

  options.rosetta.homeManagerModules =
    with types;
    mkOption { type = submodule { freeformType = attrsOf unspecified; }; };

  config.rosetta.homeManagerModules = import ../../modules/home-manager rosetta;
}
