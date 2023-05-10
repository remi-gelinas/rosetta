{
  lib,
  inputs,
  config,
  ...
}: let
  mkSystem = {
    system,
    primaryUser,
    modules ? [],
    homeModules ? [],
  }: let
    pkgs = import inputs.nixpkgs-stable {
      inherit system;
      config = config.remi-nix.nixpkgsConfig;
    };
    nur = import inputs.nur {
      nurpkgs = pkgs;
      pkgs = throw "nixpkgs eval";
    };
  in {
    inherit system;

    primaryUser =
      primaryUser
      // {
        gpgKey = rec {
          master = "3393D1E11D5CA44F06A809DB8661D12F66E5070C";

          subkeys = {
            authentication = "9DCF2C0022213A78B20A8CCE61E8ED0C55C0FE3E";
            encryption = "A799BCF5EC76C2626E831B8E412FD0A804B6 C182";
            signing = "E029B3CBB21F86F30842BC80F953929D57ECBAC0";
          };

          publicKey = let
            keyFile = pkgs.fetchurl {
              url = "https://keys.openpgp.org/vks/v1/by-fingerprint/${master}";
              sha256 = "sha256-wy6Cqo7cJ2J4+FVJTARH/a5xzLedKlHZej35+8aoHf8=";
            };
          in
            builtins.readFile keyFile;
        };
      };

    homeModules =
      [
        nur.repos.rycee.hmModules.emacs-init
        {
          inherit (config.remi-nix) nixpkgsConfig;
        }
      ]
      ++ homeModules;

    modules =
      [
        {
          inherit (config.remi-nix) nixpkgsConfig;
        }
      ]
      ++ modules;
  };
in {
  config.remi-nix.darwinConfigurations.M1 = mkSystem {
    system = "aarch64-darwin";

    primaryUser = rec {
      fullName = "Remi Gelinas";
      username = "rgelinas";
      email = "mail@remigelin.as";
      nixConfigDirectory = "/Users/${username}/.config/nixpkgs";
    };
  };

  config.remi-nix.darwinConfigurations.M1-ci = mkSystem {
    system = "x86_64-darwin";

    primaryUser = rec {
      username = "runner";
      fullName = "";
      email = "";
      nixConfigDirectory = "/Users/${username}/work/nixpkgs/nixpkgs";
    };

    modules = [{homebrew.enable = lib.mkForce false;}];
  };
}
