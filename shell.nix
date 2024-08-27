{
  pkgs ? import <nixpkgs> { },
}:
let
  pre-commit = import ./pre-commit-hooks.nix { inherit pkgs; };
in
pkgs.mkShell {
  name = "rosetta-env";

  shellHook = ''
    ${pre-commit.shellHook}
  '';

  buildInputs = with pkgs; [
    pre-commit.enabledPackages
    nixd
    nix-update
    nixfmt-rfc-style
    npins
    nvfetcher
  ];
}
