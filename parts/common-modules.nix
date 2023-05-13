{lib, ...} @ args: let
  inherit (lib) mkOption types;
in {
  options.flake.commonModules = mkOption {
    type = types.lazyAttrsOf types.unspecified;
    default = {};
  };

  config.flake.commonModules = import ../modules/common args;
}
