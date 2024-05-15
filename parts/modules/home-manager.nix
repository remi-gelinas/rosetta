local:
{ lib, inputs, ... }:
{
  _file = ./home-manager.nix;

  options.homeManagerModules = lib.mkOption { type = lib.types.attrsOf lib.types.unspecified; };

  config.homeManagerModules = import ../../modules/home-manager { inherit local inputs; };
}
