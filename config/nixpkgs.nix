{lib, ...}: let
  cfg = {
    allowUnfree = true;
  };
in {
  options.remi-nix = {
    nixpkgsConfig =
      (import ../common/nixpkgs-config.nix {inherit lib;}).options.nixpkgsConfig
      // {
        default = cfg;
      };
  };
}
