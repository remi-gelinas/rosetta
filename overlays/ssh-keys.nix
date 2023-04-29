self: super: {
  lib =
    super.lib
    // {
      sshKeys = {
        remi = let
          fingerprint = "E029B3CBB21F86F30842BC80F953929D57ECBAC0";

          # Fetch public key from openpgp.org
          key = super.fetchurl {
            url = "https://keys.openpgp.org/vks/v1/by-fingerprint/${fingerprint}";
            sha256 = "sha256-wy6Cqo7cJ2J4+FVJTARH/a5xzLedKlHZej35+8aoHf8=";
          };
        in {
          id = fingerprint;
          pubkey = builtins.readFile key;
        };
      };
    };
}
