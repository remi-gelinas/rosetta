{
  config,
  lib,
  pkgs,
  ...
}:
{
  nix = {
    # Add inputs to path for channel compatibility
    nixPath = lib.mapAttrsToList (flake: _: "${flake}=flake:${flake}") config.nix.registry;

    settings = {
      trusted-users = [ "@admin" ];

      # FIXME: https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = false;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      sandbox = true;
      cores = 0;
      max-jobs = "auto";
    };

    gc = {
      automatic = true;

      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };

      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;

    configureBuildUsers = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
}
