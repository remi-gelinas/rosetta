{
  lib,
  inputs,
  ...
}: rec {
  config.remi-nix.darwinConfigurations.M1 = rec {
    system = "aarch64-darwin";

    primaryUser = let
      inherit (import inputs.nixpkgs-stable {inherit system;}) fetchurl;
    in rec {
      fullName = "Remi Gelinas";
      username = "rgelinas";
      email = "mail@remigelin.as";
      nixConfigDirectory = "/Users/${username}/.config/nixpkgs";

      gpgKey = rec {
        master = "3393D1E11D5CA44F06A809DB8661D12F66E5070C";

        subkeys = {
          authentication = "9DCF 2C00 2221 3A78 B20A  8CCE 61E8 ED0C 55C0 FE3E";
          encryption = "A799 BCF5 EC76 C262 6E83  1B8E 412F D0A8 04B6 C182";
          signing = "E029 B3CB B21F 86F3 0842  BC80 F953 929D 57EC BAC0";
        };

        publicKey = let
          keyFile = fetchurl {
            url = "https://keys.openpgp.org/vks/v1/by-fingerprint/${master}";
            sha256 = "sha256-wy6Cqo7cJ2J4+FVJTARH/a5xzLedKlHZej35+8aoHf8=";
          };
        in
          builtins.readFile keyFile;
      };
    };

    homeModules = let
      nur-no-pkgs = import inputs.nur {
        nurpkgs = import inputs.nixpkgs-stable {inherit system;};
        pkgs = throw "nixpkgs eval";
      };
    in [
      nur-no-pkgs.repos.rycee.hmModules.emacs-init
    ];
  };

  config.remi-nix.darwinConfigurations.M1-ci =
    config.remi-nix.darwinConfigurations.M1
    // {
      system = "x86_64-darwin";

      primaryUser = {
        username = "runner";
        fullName = "";
        email = "";
        nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
      };

      modules = [{homebrew.enable = lib.mkForce false;}];
    };
}
