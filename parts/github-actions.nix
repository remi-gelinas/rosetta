localFlake:
{ config, ... }:
let
  inherit (localFlake.inputs) nix-github-actions;

  # Architecture -> Github Runner label mappings
  platforms = {
    x86_64-linux = "ubuntu-latest";
    aarch64-darwin = "macos-14";
  };
in
{
  flake.githubActions = nix-github-actions.lib.mkGithubMatrix {
    inherit platforms;
    inherit (config.flake) checks;
  };
}
