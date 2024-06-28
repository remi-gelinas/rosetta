{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.aerospace;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.programs.aerospace = with types; {
    enable = mkEnableOption "aerospace";

    package = mkPackageOption pkgs "aerospace" { };

    config = mkOption {
      type = submodule {
        freeformType = attrsOf unspecified;

        options.on-window-detected = mkOption {
          type = listOf (submodule {
            options = {
              "if".app-id = mkOption { type = str; };
              run = mkOption { type = str; };
            };
          });
        };
      };

      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."aerospace/aerospace.toml" = mkIf (cfg.config != { }) {
      source = tomlFormat.generate "aerospace-config" cfg.config;
    };
  };
}
