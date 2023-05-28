{
  withSystem,
  inputs,
  config,
}: {lib, ...}: let
  inherit (lib) mkOption types;
  homeManagerModules = import ../modules/home-manager {inherit withSystem config inputs;};
in {
  options.homeManagerModules = mkOption {
    type = types.attrsOf types.unspecified;
  };

  config.homeManagerModules = homeManagerModules;
  config.flake.homeManagerModules = config.homeManagerModules;
}
