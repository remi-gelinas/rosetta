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
      devShells.default = pkgs.mkShell {
        name = "rosetta";

        nativeBuildInputs = with pkgs; [
          preCommitConfig.settings.package
          nixfmt-rfc-style
          nix-update
          nixd
        ];

        shellHook = ''
          ${preCommitConfig.installationScript}
        '';
      };

      checks = lib.mapAttrs' (name: shell: lib.nameValuePair "devshell-${name}" shell) config.devShells;
    };
}
