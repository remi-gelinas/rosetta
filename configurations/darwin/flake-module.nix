{
  self,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./m1.nix
  ];

  options = {
    flake = mkSubmoduleOptions {
      darwinConfigurations = mkOption {
        type = types.lazyAttrsOf types.raw;
        default = {};
      };
    };
  };
}
