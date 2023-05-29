localFlake: {lib, ...} @ args:
with lib; {
  options.commonModules = mkOption {
    type = types.lazyAttrsOf types.unspecified;
  };

  options.flake.commonModules = mkOption {
    type = types.lazyAttrsOf types.unspecified;
    default = localFlake.config.commonModules;
  };

  config.commonModules = import ../modules/common args;
  config.flake.commonModules = localFlake.config.commonModules;
}
