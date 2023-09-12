localFlake: {lib, ...}:
with lib; {
  options.nixosModules = mkOption {
    type = types.attrsOf types.unspecified;
  };

  config.nixosModules = import ../modules/nixos localFlake;
  config.flake.nixosModules = localFlake.config.nixosModules;
}
