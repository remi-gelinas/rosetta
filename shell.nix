{nix-pre-commit-hooks, ...} @ inputs: {pkgs}: let
  pre-commit-check = nix-pre-commit-hooks.lib.${pkgs.stdenv.system}.run {
    src = ./.;

    hooks = {
      alejandra.enable = true;
    };
  };
in
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      nixFlakes
      nixfmt
      git
    ];

    shellHook = ''
      ${pre-commit-check.shellHook}
    '';
  }
