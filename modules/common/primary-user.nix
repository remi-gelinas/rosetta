{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  _file = ./primary-user.nix;

  options.rosetta.primaryUser = mkOption {
    type = types.submodule (
      { config, ... }:
      {
        options = {
          name = mkOption { type = types.str; };
          username = mkOption { type = types.str; };
          email = mkOption { type = types.str; };
          nixConfigDirectory = mkOption { type = types.str; };
          gpg = {
            publicKey = mkOption { type = types.str; };
            subkeys = mkOption { type = types.lazyAttrsOf types.str; };
          };
        };

        config.nixConfigDirectory = "/Users/${config.username}/.config/nixpkgs";
      }
    );
  };
}
