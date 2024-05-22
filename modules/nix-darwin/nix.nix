{ nixpkgs, nix, ... }:
{ lib, pkgs, ... }:
{
  _file = ./nix.nix;

  nix = {
    package = nix.packages.${pkgs.system}.default;

    registry = {
      nixpkgs.flake = nixpkgs;
    };

    nixPath = [ { nixpkgs = "flake:nixpkgs"; } ];

    settings = {
      trusted-users = [ "@admin" ];

      # https://github.com/NixOS/nix/issues/7273
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
