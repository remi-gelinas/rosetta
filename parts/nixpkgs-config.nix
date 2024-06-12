{
  imports = [ (import ../modules/common).nixpkgsConfig ];

  config.rosetta.nixpkgsConfig = {
    allowUnfree = true;
  };
}
