{
  lib,
  config,
  flake-parts-lib,
  ...
}: let
  inherit (lib) mkOption types;
  inherit (flake-parts-lib) mkSubmoduleOptions;
in {
  options = {
    remi-nix = mkSubmoduleOptions {
      nixpkgsConfig = mkOption {
        type = types.anything;
        default = config.remi-nix.nixpkgsConfig;
      };
    };
  };

  config.remi-nix.nixpkgsConfig = {
    allowUnfree = true;
  };
}
