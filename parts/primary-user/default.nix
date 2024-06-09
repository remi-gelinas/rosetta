{ lib, ... }:
{
  _file = ./default.nix;

  imports = [ (import ../../modules/common).primaryUser ];

  config.rosetta.primaryUser = {
    name = "Remi Gelinas";
    username = "rgelinas";
    email = lib.mkDefault "mail@remigelin.as";

    gpg = {
      publicKey = builtins.readFile ./pubkey.asc;

      subkeys = {
        authentication = "9DCF2C0022213A78B20A8CCE61E8ED0C55C0FE3E";
        encryption = "A799BCF5EC76C2626E831B8E412FD0A804B6C182";
        signing = "E029B3CBB21F86F30842BC80F953929D57ECBAC0";
      };
    };
  };
}
