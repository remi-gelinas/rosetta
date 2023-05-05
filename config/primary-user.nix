{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.remi-nix.primaryUser;
in {
  options = {
    remi-nix = {
      primaryUser = rec {
        username = mkOption {
          type = types.str;
          default = cfg.username;
        };
        fullName = mkOption {
          type = types.str;
          default = cfg.fullName;
        };
        email = mkOption {
          type = types.str;
          default = cfg.email;
        };
        nixConfigDirectory = mkOption {
          type = types.str;
          default = cfg.nixConfigDirectory;
        };
        gpgKey = {
          master = mkOption {
            type = types.str;
            default = cfg.gpgKey.master;
          };
          publicKey = mkOption {
            type = types.str;
            default = cfg.gpgKey.publicKey;
          };
          subkeys = {
            authentication = mkOption {
              type = types.str;
              default = cfg.gpgKey.subkeys.authentication;
            };
            encryption = mkOption {
              type = types.str;
              default = cfg.gpgKey.subkeys.encryption;
            };
            signing = mkOption {
              type = types.str;
              default = cfg.gpgKey.subkeys.signing;
            };
          };
        };
      };
    };
  };

  config.remi-nix.primaryUser = {
    username = "rgelinas";
    fullName = "Remi Gelinas";
    email = "mail@remigelin.as";
    nixConfigDirectory = "/Users/${config.remi-nix.primaryUser.username}/.config/nixpkgs";

    gpgKey = {
      master = "3393 D1E1 1D5C A44F 06A8  09DB 8661 D12F 66E5 070C";

      subkeys = {
        authentication = "9DCF 2C00 2221 3A78 B20A  8CCE 61E8 ED0C 55C0 FE3E";
        encryption = "A799 BCF5 EC76 C262 6E83  1B8E 412F D0A8 04B6 C182";
        signing = "E029 B3CB B21F 86F3 0842  BC80 F953 929D 57EC BAC0";
      };

      publicKey = ''
        -----BEGIN PGP PUBLIC KEY BLOCK-----

        xjMEXiI6ixYJKwYBBAHaRw8BAQdAn6M3nwLXaChRpIqgHvsZqY8wA8nzj6cSXOJ9
        xuT7Mz3NQ1JlbWkgR2VsaW5hcyAoUmVwbGFjZXMgcmVtaUByZW1pZ2VsaW5hcy5j
        bG91ZCkgPHJlbWlAZ2VsaW5hcy5jbG91ZD7CjQQTFgoANQIbAQgLCQgHDQwLCgUV
        CgkICwIeAQIXgBYhBDOT0eEdXKRPBqgJ24Zh0S9m5QcMBQJkS+BYAAoJEIZh0S9m
        5QcMwCIA/jcqmFhEqfvL/rRWYqAogfIB1eyycf0ssQnx2ESauNUVAP931mfKTBZU
        cAmOHpKxObMPToxIkeogRSgADMYgBdjlCs0gUmVtaSBHZWxpbmFzIDxtYWlsQHJl
        bWlnZWxpbi5hcz7CkAQTFgoAOAIbAQgLCQgHDQwLCgUVCgkICwIeAQIXgAIZARYh
        BDOT0eEdXKRPBqgJ24Zh0S9m5QcMBQJkS+BQAAoJEIZh0S9m5QcMfGAA/2NVm5Uf
        Fola86Tz4oOaSJ6SbxR1BF2Hf7kQ7KE0CHn9AQD2mS/HUR03Aeih1ZHmTSIiBspR
        RHSX3bEvhZmrLAhnAc0kUmVtaSBHZWxpbmFzIDxyZ2VsaW5hc0Btb21lbnRpdmUu
        YWk+wo0EExYKADUWIQQzk9HhHVykTwaoCduGYdEvZuUHDAUCZEviFwIbAQgLCQgH
        DQwLCgUVCgkICwIeAQIXgAAKCRCGYdEvZuUHDKT7AP44PelsJoQjsr6DAicQmoZi
        e8QUVWWsC0G5Z3wtIknYtgEAka6WgZrvHC6MQqSylwOvcsry4Znaft/qt+Zzb+CN
        LATNKFJlbWkgR2VsaW5hcyA8cmdlbGluYXNAc3VydmV5bW9ua2V5LmNvbT7CjQQT
        FgoANRYhBDOT0eEdXKRPBqgJ24Zh0S9m5QcMBQJkS+IqAhsBCAsJCAcNDAsKBRUK
        CQgLAh4BAheAAAoJEIZh0S9m5QcMwlUBAOUH2jyTCsSEfA/lD8QzLqpyUnFCVtf5
        RccaZ5GGzANeAQDGWvlei9N4548+eRK2xWUEo4xR9ZIrt0fMeqj/gTagBM7BTQRi
        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
        =NmON
        -----END PGP PUBLIC KEY BLOCK-----
      '';
    };
  };
}
