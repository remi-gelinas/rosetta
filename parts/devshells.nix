{
  perSystem =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      preCommitConfig = config.pre-commit;
    in
    {
      devShells.default = config.devShells.rosetta;

      devShells.rosetta = pkgs.mkShell {
        name = "rosetta";

        nativeBuildInputs = with pkgs; [
          preCommitConfig.settings.package
          nixd
          lix
          nixfmt-rfc-style
          nix-update
        ];

        shellHook = ''
          ${preCommitConfig.installationScript}
        '';
      };

      checks = lib.mapAttrs' (name: shell: lib.nameValuePair "devshell-${name}" shell) (
        # Remove the default devshell alias to avoid evaluating/building twice in CI
        builtins.removeAttrs config.devShells [ "default" ]
      );
    };
}
