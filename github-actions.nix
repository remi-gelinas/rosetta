{
  pkgs ? import <nixpkgs> { },
  checks ? { },
}:
let
  inherit (pkgs) lib;

  dependencies = import ./_dependencies/generated.nix {
    inherit (pkgs)
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };

  github-actions = import dependencies.github-actions.src;

  addJobNames =
    m:
    m
    // {
      matrix.include = map (
        job: job // { name = lib.strings.removePrefix "githubActions.checks." job.attr; }
      ) m.matrix.include;
    };

  matrix = addJobNames (
    github-actions.mkGithubMatrix {
      # Architecture -> Github Runner label mappings
      platforms = {
        x86_64-linux = "ubuntu-latest";
        aarch64-darwin = "macos-14";
      };

      inherit checks;
    }
  );
in
matrix
