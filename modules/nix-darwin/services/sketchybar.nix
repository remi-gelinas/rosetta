{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.sketchybar;

  configFile = mkIf (cfg.config != "") "${
    pkgs.writeScript "sketchybarrc" "${cfg.config}"
  }";
in {
  options = {
    services.sketchybar.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable sketchybar";
    };

    services.sketchybar.package = mkOption {
      type = types.path;
      default = pkgs.sketchybar;
      description = "The sketchybar package to use.";
    };

    services.sketchybar.config = mkOption {
      type = types.str;
      default = "";
      example = literalExpression ''
        sketchybar --bar height=24
        sketchybar --update
        echo "sketchybar configuration loaded.."
      '';
      description = ''
        Content of configuration file. See <link xlink:href="https://felixkratz.github.io/SketchyBar/">documentation</link> and <link xlink:href="https://github.com/FelixKratz/SketchyBar/blob/master/sketchybarrc">example</link>.
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = [cfg.package];
      launchd.user.agents.sketchybar.serviceConfig = {
        ProgramArguments = ["${cfg.package}/bin/sketchybar"] ++ optionals (cfg.config != "") ["-c" configFile];
        KeepAlive = true;
        RunAtLoad = true;
        EnvironmentVariables = {
          PATH = "${cfg.package}/bin:${config.environment.systemPath}";
        };
      };
    })

    # Actual config
    {
      services.sketchybar = {
        enable = true;

        config = ''
          sketchybar --update
        '';
      };
    }
  ];
}
