{
  _file = ./nixpkgs-config.nix;

  imports = [ (import ../modules/common).nixpkgsConfig ];

  config.rosetta.nixpkgsConfig = {
    allowUnfree = true;
  };
}
