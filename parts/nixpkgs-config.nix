{lib, ...}: let
  cfg = {
    allowUnfree = true;
  };
in {
  options.rosetta.nixpkgsConfig = (import ../modules/common/nixpkgs-config.nix {inherit lib;}).options.nixpkgsConfig;
  config.rosetta.nixpkgsConfig = cfg;
}
