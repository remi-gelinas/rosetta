# deadnix: skip
{nix-pre-commit-hooks, ...} @ _inputs: {pkgs}: let
  pre-commit-check = nix-pre-commit-hooks.lib.${pkgs.stdenv.system}.run {
    src = ./.;

    hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      statix.enable = true;

      commitizen.enable = true;
    };
  };
in
  pkgs.mkShell {
    name = "nixpkgs";

    nativeBuildInputs = with pkgs; [
      nixFlakes
      nixfmt
      git
    ];

    shellHook = ''
      ${pre-commit-check.shellHook}
    '';
  }
