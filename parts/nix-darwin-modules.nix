localFlake: { lib, ... }:
with lib; {
  options.darwinModules = mkOption {
    type = types.attrsOf types.unspecified;
  };

  config.darwinModules = import ../modules/nix-darwin localFlake;
  config.flake.darwinModules = localFlake.config.darwinModules;
}
