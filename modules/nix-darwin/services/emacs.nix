{self, ...}: {
  pkgs,
  config,
  ...
}: let
  inherit (self.packages.${pkgs.system}) emacs;
in {
  launchd.user.agents.emacs = {
    path = [config.environment.systemPath];

    serviceConfig = let
      binPath = "${emacs}/Applications/Emacs.app/Contents/MacOS/Emacs";
    in {
      KeepAlive = true;

      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path ${binPath} && exec ${binPath} --fg-daemon"
      ];

      StandardErrorPath = "/tmp/emacs.err.log";
      StandardOutPath = "/tmp/emacs.out.log";
    };
  };
}
