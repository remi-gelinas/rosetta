{ local }:
{
  _file = ./devshells.nix;

  perSystem =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (local.inputs) nixd lix;

      preCommitConfig = config.pre-commit;
    in
    {
      devShells.default = config.devShells.rosetta;

      devShells.rosetta = pkgs.mkShell {
        name = "rosetta";

        nativeBuildInputs = [
          preCommitConfig.settings.package
          lix.packages.${pkgs.system}.default
          nixd.packages.${pkgs.system}.nixd
          pkgs.nixfmt-rfc-style
          pkgs.nix-update
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
