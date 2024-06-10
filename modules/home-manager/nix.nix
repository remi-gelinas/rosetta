{ rosetta, ... }:
{
  nix.registry = {
    nixpkgs.flake = rosetta.inputs.nixpkgs;
  };
}
