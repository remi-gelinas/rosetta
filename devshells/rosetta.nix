{withSystem}: {
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

      (withSystem pkgs.system ({inputs', ...}: inputs'.nix.packages.nix))
      alejandra
      nvfetcher
    ];

    shellHook = ''
      ${cfg.installationScript}
    '';
  }
