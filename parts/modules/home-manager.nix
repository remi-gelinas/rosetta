{ local }:
{ lib, ... }:
with lib;
{
  _file = ./home-manager.nix;

  options.rosetta.homeManagerModules =
    with types;
    mkOption { type = submodule { freeformType = attrsOf unspecified; }; };

  config.rosetta.homeManagerModules =
    let
      modules = (import ../../modules/top-level/all-modules.nix { inherit lib; }).home;
    in
    mapAttrs (_: path: import path { inherit local; }) modules;
}
