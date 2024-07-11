{
  imports = [ ../modules/common/nixpkgs-config.nix ];

  config.rosetta.nixpkgsConfig = {
    allowUnfree = true;
  };
}
