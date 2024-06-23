{ lib, ... }:
with lib;
{
  options.rosetta.primaryUser =
    with types;
    mkOption {
      type = types.submodule (
        { config, ... }:
        {
          options = {
            name = mkOption { type = str; };
            username = mkOption { type = str; };
            email = mkOption { type = str; };
            nixConfigDirectory = mkOption { type = str; };
            gpg = {
              publicKey = mkOption { type = str; };
              subkeys = mkOption { type = attrsOf str; };
            };
          };

          config.nixConfigDirectory = "/Users/${config.username}/.config/nixpkgs";
        }
      );
    };
}
