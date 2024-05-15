{ lib, inputs, ... }:
{
  options.homeManagerModules = lib.mkOption { type = lib.types.attrsOf lib.types.unspecified; };

  config.homeManagerModules = import ../../modules/home-manager inputs;
}
