{
  withSystem,
  config,
  inputs,
}: {lib, ...}: let
  inherit (lib) mkOption types;
  darwinModules = import ../modules/nix-darwin {inherit withSystem config inputs;};
in {
  options.darwinModules = mkOption {
    type = types.attrsOf types.unspecified;
  };

  config.darwinModules = darwinModules;
  config.flake.darwinModules = config.darwinModules;
}
