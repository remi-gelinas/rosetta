{
  config,
  inputs,
  withSystem,
  ...
}:
let
  inherit (inputs) github-actions;

  # Architecture -> Github Runner label mappings
  platforms = {
    x86_64-linux = "ubuntu-latest";
    aarch64-darwin = "macos-14";
  };
in
{
  _file = ./github-actions.nix;

  flake.githubActions = github-actions.lib.mkGithubMatrix {
    inherit platforms;

    checks = {
      x86_64-linux = {
        inherit (withSystem "x86_64-linux" ({ config, ... }: config.checks)) pre-commit;
      };

      aarch64-darwin = {
        ci = config.darwinConfigurations.ci.system;
      };
    };
  };
}
