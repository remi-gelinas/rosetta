{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.caches;
in
{
  _file = ./default.nix;

  config.caches =
    let
      cacheConfig = lib.importJSON ./caches.json;

      cachixCaches = map (
        { name, publicKey }:
        {
          name = "https://${name}.cachix.org";
          inherit publicKey;
        }
      ) cacheConfig.cachix;
    in
    lib.mkDefault (cachixCaches ++ cacheConfig.nix);

  options.caches = mkOption {
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
    trusted-substituters = map ({ name, ... }: name) cfg;
    trusted-public-keys = map ({ publicKey, ... }: publicKey) cfg;
  };

  config.environment.systemPackages = [ pkgs.cachix ];
}
