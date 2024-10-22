{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    strings
    mkOption
    types
    filterAttrs
    ;

  inherit (inputs) github-actions;

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
  options.flake.githubActions = mkOption { type = types.unspecified; };

  config.flake.githubActions =
    let
      # Architecture -> Github Runner label mappings
      platforms = {
        x86_64-linux = "ubuntu-latest";
        aarch64-darwin = "macos-14";
      };
    in
    addJobName (
      github-actions.lib.mkGithubMatrix {
        inherit platforms;

        # Only include checks with supported GHA runners
        checks = filterAttrs (k: _: platforms ? "${k}") config.flake.checks;
      }
    );
}
