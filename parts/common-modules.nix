localFlake: {lib, ...} @ args: let
  inherit (lib) mkOption types;
in {
  options.commonModules = mkOption {
    type = types.lazyAttrsOf types.unspecified;
  };

  options.flake.commonModules = mkOption {
    type = types.lazyAttrsOf types.unspecified;
    default = localFlake.config.commonModules;
  };

  config.commonModules = import ../modules/common args;
}
