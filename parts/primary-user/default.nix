{ lib, config, ... }:
{
  options.primaryUser =
    (import config.commonModules.primaryUser { inherit lib; }).options.users.primaryUser;

  config.primaryUser = rec {
    fullName = "Remi Gelinas";
    username = "rgelinas";
    email = "mail@remigelin.as";
    nixConfigDirectory = "/Users/${username}/.config/nixpkgs";

    gpgKey = {
      master = "3393D1E11D5CA44F06A809DB8661D12F66E5070C";

      subkeys = {
        authentication = "9DCF2C0022213A78B20A8CCE61E8ED0C55C0FE3E";
        encryption = "A799BCF5EC76C2626E831B8E412FD0A804B6 C182";
        signing = "E029B3CBB21F86F30842BC80F953929D57ECBAC0";
      };

      publicKey = builtins.readFile ./pubkey.asc;
    };
  };
}
