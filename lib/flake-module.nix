{
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (lib) mkOption types;
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  imports = [
    ./mkDarwinSystem.nix
    ./colors.nix
  ];

  options = {
    lib = mkOption {
      type = types.anything;
    };
  };
}
