{config, ...}: {lib, ...} @ args: let
  inherit (lib) mkOption types;
  darwinModules = import ../modules/nix-darwin args;
in {
  options.darwinModules = mkOption {
    type = types.attrsOf types.unspecified;
  };

  config.darwinModules = darwinModules;
  config.flake.darwinModules = config.darwinModules;
}
