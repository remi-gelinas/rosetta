rosetta:
{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  _file = ./rosetta-bridge.nix;

  options.rosetta.inputs = with types; mkOption { type = attrsOf unspecified; };

  config.rosetta.inputs = rosetta.inputs // {
    nixpkgs-master = import rosetta.inputs.nixpkgs-master {
      inherit (pkgs) system;
      inherit (config.nixpkgs) config;
    };
  };

  config.nixpkgs.config = rosetta.config.rosetta.nixpkgsConfig;

  config.nix.registry.nixpkgs.flake = config.rosetta.inputs.nixpkgs;
}
