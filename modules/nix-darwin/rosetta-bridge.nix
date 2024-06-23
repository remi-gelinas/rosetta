rosetta:
{ lib, ... }:
with lib;
{
  _file = ./rosetta-bridge.nix;

  options.rosetta.inputs = with types; mkOption { type = attrsOf unspecified; };

  config = {
    rosetta.inputs = rosetta.inputs;
    nixpkgs.config = rosetta.config.rosetta.nixpkgsConfig;
    nix.registry.nixpkgs.flake = rosetta.inputs.nixpkgs;
  };
}
