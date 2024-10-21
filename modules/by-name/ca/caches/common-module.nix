{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.caches;
in
{
  config.caches =
    let
      cacheConfig = importJSON ./caches.json;

      cachixCaches = map (
        { name, publicKey }:
        {
          name = "https://${name}.cachix.org";
          inherit publicKey;
        }
      ) cacheConfig.cachix;
    in
    mkDefault (cachixCaches ++ cacheConfig.nix);

  options.caches =
    with types;
    mkOption {
      type = listOf (submodule {
        options = {
          name = mkOption { type = str; };
          publicKey = mkOption { type = str; };
        };
      });
    };

  config = {
    environment.systemPackages = [ pkgs.cachix ];

    nix.settings = {
      trusted-substituters = map ({ name, ... }: name) cfg;
      trusted-public-keys = map ({ publicKey, ... }: publicKey) cfg;
    };
  };
}
