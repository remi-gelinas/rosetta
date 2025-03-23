{ lib, pkgs, ... }:
{
  imports = [ ./common-module.nix ];

  nix = {
    settings = {
      auto-optimise-store = true;

      extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };

    gc.interval = {
      Weekday = 0;
      Hour = 0;
      Minute = 0;
    };
  };

  # TODO: Remove once https://github.com/LnL7/nix-darwin/pull/1335 lands
  users.knownUsers = lib.mkForce [ ];
  users.knownGroups = lib.mkForce [ ];
}
