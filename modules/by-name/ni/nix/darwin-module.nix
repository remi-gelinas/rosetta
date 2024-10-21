{ lib, pkgs, ... }:
{
  imports = [ ./common-module.nix ];

  nix = {
    configureBuildUsers = true;

    settings = {
      # FIXME: https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = false;

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

    optimise.automatic = true;
  };

  services.nix-daemon = {
    enable = true;
  };
}
