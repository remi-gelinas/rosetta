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
      homeStateVersion = mkOption {
        type = types.str;
        default = config.remi-nix.homeStateVersion;
      };
    };
  };

  config.remi-nix.homeStateVersion = "23.05";
}
