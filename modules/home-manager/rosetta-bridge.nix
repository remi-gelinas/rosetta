rosetta: {
  _file = ./rosetta-bridge.nix;

  nixpkgs.config = rosetta.config.rosetta.nixpkgsConfig;
}
