{
  lib,
  config,
  inputs,
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

    inherit (config.flake) checks;
  };
}
