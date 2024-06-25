{ rosetta }:
{ lib, ... }:
with lib;
let
  inherit (rosetta.inputs) lix-module home-manager;
in
{
  _file = ./nix-darwin.nix;

  options.rosetta.darwinModules =
    with types;
    mkOption { type = submodule { freeformType = attrsOf unspecified; }; };

  config.rosetta.darwinModules = (import ../../modules/nix-darwin rosetta) // {
    # Re-export modules from home-manager and Lix to ensure downstream flakes can build the config
    inherit (home-manager.darwinModules) home-manager;
    lix = lix-module.nixosModules.default;
  };
}
