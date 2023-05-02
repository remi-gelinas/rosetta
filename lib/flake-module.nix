{
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (lib) mkOption types;
  inherit (flake-parts-lib) mkPerSystemOption mkSubmoduleOptions;
in {
  imports = [
    ./mkDarwinSystem.nix
    ./nixpkgs-sets.nix
  ];

  options = {
    perSystem = mkPerSystemOption (_: {
      options = {
        lib = mkOption {
          type = types.anything;
        };
      };
    });
  };
}
