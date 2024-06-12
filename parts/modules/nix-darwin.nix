{ rosetta }:
{ lib, ... }:
with lib;
{
  _file = ./nix-darwin.nix;

  options.rosetta.darwinModules =
    with types;
    mkOption { type = submodule { freeformType = attrsOf unspecified; }; };

  config.rosetta.darwinModules = import ../../modules/nix-darwin rosetta;
}
