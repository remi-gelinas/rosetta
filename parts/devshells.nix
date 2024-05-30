{
  _file = ./devshells.nix;

  perSystem =
    {
      config,
      pkgs,
      lib,
      inputs',
      system,
      ...
    }:
    let
      preCommitConfig = config.pre-commit;
    in
    {
      devShells.default = config.devShells.rosetta;

      devShells.rosetta = pkgs.mkShell {
        name = "rosetta";

        nativeBuildInputs = [
          preCommitConfig.settings.package
          inputs'.lix.packages.default
          inputs'.nixd.packages.nixd
          pkgs.statix
          pkgs.deadnix
          pkgs.nixfmt-rfc-style
          inputs'.nvfetcher.packages.default
        ];

        shellHook = ''
          ${preCommitConfig.installationScript}
        '';
      };

      devShells.ci = pkgs.mkShell {
        name = "ci-${system}";
        nativeBuildInputs = [ inputs'.lix.packages.default ];
      };

      checks = lib.mapAttrs' (name: shell: lib.nameValuePair "devshell-${name}" shell) config.devShells;
    };
}
