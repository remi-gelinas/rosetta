rosetta:
{ pkgs, ... }:
{
  _file = ./rosetta-bridge.nix;

  _module.args = {
    inherit rosetta;

    pkgs-master = import rosetta.inputs.nixpkgs-master {
      inherit (pkgs) system;
      config = rosetta.config.rosetta.nixpkgsConfig;
    };
  };
}
