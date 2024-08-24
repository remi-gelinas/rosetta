{ local }:
{ lib, ... }:
with lib;
let
  inherit (local.inputs) lix-module home-manager nix-homebrew;
in
{
  _file = ./nix-darwin.nix;

  options.rosetta.darwinModules =
    with types;
    mkOption { type = submodule { freeformType = attrsOf unspecified; }; };

  config.rosetta.darwinModules =
    let
      modules = (import ../../modules/top-level/all-modules.nix { inherit lib; }).darwin;
    in
    (mapAttrs (_: path: import path { inherit local; }) modules)
    // {
      # Re-export modules from inputs to ensure downstream flakes can build the config
      home-manager-module = home-manager.darwinModules.home-manager;
      nix-homebrew-module = nix-homebrew.darwinModules.nix-homebrew;
      lix-module = lix-module.nixosModules.lixFromNixpkgs;
    };
}
