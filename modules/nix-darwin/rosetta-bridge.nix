rosetta: {
  _file = ./rosetta-bridge.nix;

  _module.args = {
    inherit rosetta;
  };
}
