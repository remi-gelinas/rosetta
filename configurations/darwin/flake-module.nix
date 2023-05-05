{lib, ...}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./m1.nix
  ];

  options = {
    flake.darwinConfigurations = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = {};
    };
  };
}
