{ withSystem, inputs }:
{ lib, pkgs, ... }:
{
  nix = {
    package = withSystem pkgs.system ({ inputs', ... }: inputs'.nix.packages.nix);

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };

    nixPath = [ "nixpkgs=flake:nixpkgs" ];

    settings = {
      trusted-users = [ "@admin" ];

      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://remi-gelinas-nix.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "remi-gelinas-nix.cachix.org-1:nj3SWe8g0jlpzvzvgE6znxY21XaONHxJ1qZQQsHBBNA="
      ];

      # https://github.com/NixOS/nix/issues/7273
      # Broken in official Nix installer, but fixed in https://github.com/DeterminateSystems/nix-installer/issues/449?
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

    configureBuildUsers = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
}
