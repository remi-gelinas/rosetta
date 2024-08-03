{ local }:
{ lib, config, ... }:
with lib;
let
  inherit (local.inputs) github-actions;

  addJobName =
    m:
    m
    // {
      matrix.include = map (
        job: job // { name = strings.removePrefix "githubActions.checks." job.attr; }
      ) m.matrix.include;
    };
in
{
  _file = ./github-actions.nix;

  options.rosetta.githubActionsMatrix = mkOption { type = types.unspecified; };

  config.rosetta.githubActionsMatrix = addJobName (
    github-actions.lib.mkGithubMatrix {
      # Architecture -> Github Runner label mappings
      platforms = {
        x86_64-linux = "ubuntu-latest";
        aarch64-darwin = "macos-14";
      };

      inherit (config.flake) checks;
    }
  );
}
