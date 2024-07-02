{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  cfg = config.programs.yubikey-agent;
in
{
  options.programs.yubikey-agent = with types; {
    enable = mkEnableOption "yubikey-agent";

    package = mkPackageOption pkgs "yubikey-agent" { };

    socket = mkOption {
      type = path;
      default = "${config.home.homeDirectory}/.yubikey-agent/yubikey-agent.sock";
    };

    logFile = mkOption {
      type = path;
      default = "${config.home.homeDirectory}/.yubikey-agent/yubikey-agent.log";
    };

    enableFishIntegration = mkOption {
      type = bool;
      default = false;
    };
  };

  config = mkMerge [
    {
      assertions = [
        {
          assertion = cfg.enable -> isDarwin;
          message = "Prefer to use the NixOS `yubikey-agent` module on non-Darwin systems.";
        }
      ];
    }
    (mkIf cfg.enable {
      launchd.agents.yubikey-agent.config = {
        ProgramArguments = [
          "${cfg.package}/bin/yubikey-agent"
          "-l"
          cfg.socket
        ];

        StandardOutPath = cfg.logFile;
        StandardErrorPath = cfg.logFile;

        KeepAlive = true;
        RunAtLoad = true;
      };
      programs.fish.interactiveShellInit = mkIf cfg.enableFishIntegration ''
        set -gx SSH_AUTH_SOCK "${cfg.socket}"
      '';
    })
  ];
}
