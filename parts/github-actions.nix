{ config, inputs, ... }:
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
    inherit (config.flake) checks;
  };
}
