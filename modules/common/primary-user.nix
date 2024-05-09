{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.users.primaryUser = {
    username = mkOption { type = types.str; };

    fullName = mkOption { type = types.str; };

    email = mkOption { type = types.str; };

    nixConfigDirectory = mkOption { type = types.str; };

    gpgKey = {
      master = mkOption { type = types.str; };

      subkeys = {
        authentication = mkOption { type = types.str; };
        encryption = mkOption { type = types.str; };
        signing = mkOption { type = types.str; };
      };

      publicKey = mkOption { type = types.str; };
    };
  };
}
