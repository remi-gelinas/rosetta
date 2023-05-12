args: rec {
  default = rosetta;
  rosetta = import ./rosetta.nix args;
}
