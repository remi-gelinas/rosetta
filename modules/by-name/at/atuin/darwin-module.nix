_: {
  # Rosetta config
  config.services.atuin-daemon.enable = true;

  # Module implementation
  imports = [
    (
      {
        config,
        pkgs,
        lib,
        ...
      }:
      with lib;
      let
        cfg = config.services.atuin-daemon;
      in
      {
        options.services.atuin-daemon = with types; {
          enable = mkEnableOption "atuin-daemon";

          package = mkPackageOption pkgs "atuin" { };
        };

        config = mkIf cfg.enable (mkMerge [
          (mkIf (versionAtLeast cfg.package.version "18.3.0") {
            launchd.user.agents.atuin-daemon.serviceConfig = {
              ProgramArguments = [
                "${cfg.package}/bin/atuin"
                "daemon"
              ];

              KeepAlive = true;
              RunAtLoad = true;
            };
          })
        ]);
      }
    )
  ];
}
