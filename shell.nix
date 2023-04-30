{
  config,
  pkgs,
  ...
}: let
  cfg = config.pre-commit;
in
  pkgs.mkShell {
    name = "nixpkgs";

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
