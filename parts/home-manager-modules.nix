localFlake: {lib, ...}:
with lib; {
  options.homeManagerModules = mkOption {
    type = types.attrsOf types.unspecified;
  };

  config.homeManagerModules = import ../modules/home-manager localFlake;
  config.flake.homeManagerModules = localFlake.config.homeManagerModules;
}
