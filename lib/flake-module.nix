{lib, ...}: let
  inherit (lib) mkOption types;
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
