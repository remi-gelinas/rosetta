{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.cachix.caches;
in
{
  _file = ./cachix.nix;

  config.cachix.caches = lib.mkDefault [
    {
      name = "nix-community";
      publicKey = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    }
    {
      name = "remi-gelinas-nix";
      publicKey = "remi-gelinas-nix.cachix.org-1:nj3SWe8g0jlpzvzvgE6znxY21XaONHxJ1qZQQsHBBNA=";
    }
  ];

  options.cachix.caches = mkOption {
    type = types.listOf (
      types.submodule {
        options = {
          name = mkOption { type = types.str; };
          publicKey = mkOption { type = types.str; };
        };
      }
    );
  };

  config.nix.settings = {
    substituters = map ({ name, ... }: "https://${name}.cachix.org") cfg;
    trusted-public-keys = map ({ publicKey, ... }: publicKey) cfg;
  };

  config.environment.systemPackages = [ pkgs.cachix ];
}
