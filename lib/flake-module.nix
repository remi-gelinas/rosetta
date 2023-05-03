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
    ./colors.nix
  ];

  options = {
    perSystem = mkPerSystemOption (_: {
      options = {
        lib = mkOption {
          type = types.anything;
        };
      };
    });

    lib = mkOption {
      type = types.anything;
    };
  };
}
