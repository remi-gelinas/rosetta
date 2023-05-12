{
  pkgs,
  config,
  ...
}: let
  cfg = config.pre-commit;
in
  pkgs.mkShell {
    name = "rosetta";

    nativeBuildInputs = with pkgs; [
      cfg.settings.package

      nixFlakes
      nixfmt
      git
    ];

    shellHook = ''
      ${cfg.installationScript}
    '';
  }
