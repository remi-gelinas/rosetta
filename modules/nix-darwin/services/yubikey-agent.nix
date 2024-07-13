{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.yubikey-agent;
in
{
  options.services.yubikey-agent = with types; {
    enable = mkEnableOption "yubikey-agent";

    package = mkPackageOption pkgs "yubikey-agent" { };

    socket = mkOption {
      type = path;
      default = "/tmp/yubikey-agent.sock";
    };

    enableFishIntegration = mkOption {
      type = bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    launchd.user.agents.yubikey-agent.serviceConfig = {
      ProgramArguments = [
        "${cfg.package}/bin/yubikey-agent"
        "-l"
        cfg.socket
      ];

      KeepAlive = true;
      RunAtLoad = true;
    };

    programs.fish.interactiveShellInit = mkIf cfg.enableFishIntegration ''
      set -gx SSH_AUTH_SOCK "${cfg.socket}"
    '';
  };
}
