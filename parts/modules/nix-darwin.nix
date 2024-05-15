{ lib, inputs, ... }:
{
  options.darwinModules = lib.mkOption { type = lib.types.attrsOf lib.types.unspecified; };

  config.darwinModules = import ../../modules/nix-darwin inputs;
}
