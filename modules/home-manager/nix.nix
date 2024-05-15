{ nixpkgs, ... }:
{
  _file = ./nix.nix;

  nix.registry = {
    nixpkgs.flake = nixpkgs;
  };
}
