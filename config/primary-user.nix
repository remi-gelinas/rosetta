{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.primary-user;
in {
  options = {
    primary-user = mkOption {
      type = types.submodule {
        options = {
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
        };
      };
    };
  };

  config.primary-user = {
    username = "rgelinas";
    fullName = "Remi Gelinas";
    email = "mail@remigelin.as";
    nixConfigDirectory = "/Users/rgelinas/.config/nixpkgs";
  };
}
