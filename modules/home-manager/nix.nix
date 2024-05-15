{ nixpkgs, ... }:
{
  nix.registry = {
    nixpkgs.flake = nixpkgs;
  };
}
