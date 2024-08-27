{
  pkgs ? import <nixpkgs> { },
}:
let
  dependencies = import ./_dependencies/generated.nix {
    inherit (pkgs)
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };

  pre-commit-hooks = import dependencies.git-hooks.src;
in
pre-commit-hooks.run {
  src = ./.;

  excludes = [
    "^_pins/.*.nix$"
    "^_dependencies/.*.nix$"
  ];

  hooks = {
    deadnix = {
      enable = true;
      package = pkgs.deadnix;
    };

    statix = {
      enable = true;
      package = pkgs.statix;

      # FIXME: https://github.com/cachix/git-hooks.nix/issues/288
      settings.ignore = [
        "_pins*"
        "_dependencies"
      ];
    };

    nixfmt = {
      enable = true;
      package = pkgs.nixfmt-rfc-style;
    };

    commitizen.enable = true;
    actionlint.enable = true;
  };
}
