{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options = {
    remi-nix = {
      nixpkgsConfig = let
        cfg = {
          allowUnfree = true;
        };
      in
        mkOption {
          type = types.anything;
          default = cfg;
        };
    };
  };
}
