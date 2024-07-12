{ config, ... }:
{
  system = "aarch64-darwin";
  homeModules = builtins.attrValues config.rosetta.homeManagerModules;
  modules = (builtins.attrValues config.rosetta.darwinModules) ++ [
    { users.users.remi = import ../../users/remi.nix; }

    # FIXME: Remove once migrated fully off of PGP SSH auth
    {
      home-manager.users.remi.gpg = {
        publicKey = builtins.readFile ./remi_pubkey.asc;

        subkeys = {
          authentication = "9DCF2C0022213A78B20A8CCE61E8ED0C55C0FE3E";
          encryption = "A799BCF5EC76C2626E831B8E412FD0A804B6C182";
          signing = "E029B3CBB21F86F30842BC80F953929D57ECBAC0";
        };
      };
    }
  ];
}
