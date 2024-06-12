allSystems: {
  perSystem =
    {
      config,
      pkgs,
      lib,
      inputs',
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
          pkgs.sops
        ];

        shellHook = ''
          ${preCommitConfig.installationScript}
        '';

        SOPS_PGP_FP = allSystems.config.rosetta.primaryUser.gpg.subkeys.encryption;
      };

      checks = lib.mapAttrs' (name: shell: lib.nameValuePair "devshell-${name}" shell) (
        # Remove the default devshell alias to avoid evaluating/building twice in CI
        builtins.removeAttrs config.devShells [ "default" ]
      );
    };
}
