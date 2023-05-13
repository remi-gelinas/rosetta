{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types mkMerge mkIf literalExpression;

  cfg = config.services.sketchybar;

  configHome = pkgs.writeTextFile {
    name = "sketchybarrc";
    text = cfg.config;
    destination = "/sketchybar/sketchybarrc";
    executable = true;
  };
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
      launchd.user.agents.sketchybar = {
        serviceConfig.ProgramArguments = ["${cfg.package}/bin/sketchybar"];
        serviceConfig.KeepAlive = true;
        serviceConfig.RunAtLoad = true;
        serviceConfig.EnvironmentVariables = {
          PATH = "${cfg.package}/bin:${config.environment.systemPath}";
          XDG_CONFIG_HOME = mkIf (cfg.config != "") "${configHome}";
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
