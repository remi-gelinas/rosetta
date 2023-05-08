{lib, ...}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./colors.nix
  ];

  options = {
    lib = mkOption {
      type = types.anything;
    };
  };
}
