{ inputs }:
{
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs-unstable;
    nixpkgs-master.flake = inputs.nixpkgs-master;
  };
}
