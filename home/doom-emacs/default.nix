{ config, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
lib.mkMerge [
  {
    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d;
      emacsPackage = pkgs.emacs27;
    };
  }
  (lib.mkIf isLinux {
    services.emacs = {
      enable = true;
    };
  })
]
