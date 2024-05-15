{
  lib,
  inputs,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.commonModules = mkOption { type = types.lazyAttrsOf types.unspecified; };

  options.flake.commonModules = mkOption {
    type = types.lazyAttrsOf types.unspecified;
    default = config.commonModules;
  };

  config.commonModules = import ../../modules/common inputs;
}
