{nix-pre-commit-hooks, ...} @ inputs: {pkgs}: let
  pre-commit-check = nix-pre-commit-hooks.lib.${pkgs.stdenv.system}.run {
    src = ./.;

    hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      statix.enable = true;
    };
  };
in
  pkgs.mkShell {
    name = "remi-gelinas/nixpkgs";

    nativeBuildInputs = with pkgs; [
      nixFlakes
      nixfmt
      git
    ];

    shellHook = ''
      ${pre-commit-check.shellHook}
    '';
  }
