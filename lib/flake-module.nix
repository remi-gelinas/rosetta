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
  ];

  options = {
    perSystem = mkPerSystemOption ({...}: {
      options = {
        flake = mkSubmoduleOptions {
          lib = mkOption {
            type = types.anything;
          };
        };
      };
    });
  };
}
