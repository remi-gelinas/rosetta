{
  lib,
  config,
  inputs,
  withSystem,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (inputs) github-actions;
in
{
  _file = ./github-actions.nix;

  options.rosetta.githubActionsMatrix = mkOption { type = types.unspecified; };

  config.rosetta.githubActionsMatrix = github-actions.lib.mkGithubMatrix {
    # Architecture -> Github Runner label mappings
    platforms = {
      x86_64-linux = "ubuntu-latest";
      aarch64-darwin = "macos-14";
    };

    checks = {
      x86_64-linux = {
        inherit (withSystem "x86_64-linux" ({ config, ... }: config.checks)) pre-commit;
      };

      aarch64-darwin = {
        ci = config.darwinConfigurations.ci.finalSystem.system;
      };
    };
  };
}
