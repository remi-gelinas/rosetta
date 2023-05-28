{withSystem, ...}: {
  pkgs,
  config,
}: rec {
  default = rosetta;
  rosetta = import ./rosetta.nix {inherit withSystem;} {inherit config pkgs;};
}
