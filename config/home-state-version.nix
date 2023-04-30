{
  lib,
  flake-parts-lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options = {
    homeStateVersion = mkOption {
      type = types.str;
      default = config.homeStateVersion;
    };
  };

  config.homeStateVersion = "23.05";
}
