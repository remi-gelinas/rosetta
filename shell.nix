{ pkgs }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nixFlakes
    nixfmt
    git
  ];
}
