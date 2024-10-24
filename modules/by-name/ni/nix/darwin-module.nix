{ local }:
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
        "auto-allocate-uids"
      ];

      extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      sandbox = true;
      cores = 0;
      max-jobs = "auto";
      auto-allocate-uids = true;
      keep-outputs = true;
      keep-derivations = true;
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

    registry = lib.pipe local.inputs [
      (v: removeAttrs v [ "self" ])
      (lib.mapAttrs (_: flake: { inherit flake; }))
    ];
  };

  services.nix-daemon = {
    enable = true;
  };
}
