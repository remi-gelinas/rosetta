{
  _file = ./devshells.nix;

  perSystem =
    {
      config,
      pkgs,
      inputs',
      ...
    }:
    {
      devShells.default =
        let
          cfg = config.pre-commit;
        in
        pkgs.mkShell {
          name = "rosetta";

          nativeBuildInputs = [
            cfg.settings.package
            inputs'.nix.packages.nix
            inputs'.nixd.packages.nixd
            pkgs.statix
            pkgs.deadnix
            pkgs.nixfmt-rfc-style
            inputs'.nvfetcher.packages.default
          ];

          shellHook = ''
            ${cfg.installationScript}
          '';
        };

      checks = config.devShells;
    };
}
