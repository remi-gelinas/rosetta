{ config, lib, ... }:
{
  nix = {
    # Add inputs to path for channel compatibility
    nixPath = lib.mapAttrsToList (flake: _: "${flake}=flake:${flake}") config.nix.registry;

    settings = {
      trusted-users = [ "@admin" ];

      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
      ];

      sandbox = false;
      cores = 0;
      max-jobs = "auto";
      auto-allocate-uids = true;
      keep-outputs = true;
      keep-derivations = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
