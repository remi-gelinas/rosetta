{ config, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  inherit (pkgs) emacsPackagesFor emacsUnstable;
in
lib.mkMerge [
  {
    programs.doom-emacs =
      {
        enable = true;
        doomPrivateDir = ./doom.d;
        emacsPackage = ((emacsPackagesFor emacsUnstable).emacsWithPackages (epkgs: with epkgs.melpaStablePackages; [ flycheck ]));
      };
  }
  (lib.mkIf isLinux {
    services.emacs = {
      enable = true;
    };
  })
]
