{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options = {
    nixpkgsConfig = mkOption {
      type = types.anything;
      default = config.nixpkgsConfig;
    };
  };

  config.nixpkgsConfig = {
    allowUnfree = true;
  };
}
