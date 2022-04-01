{ config, lib, pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      userEmail = config.home.user-info.email;
      userName = config.home.user-info.fullName;
      signing = {
        signByDefault = true;
        key = pkgs.lib.sshKeys.remi.id;
      };

      ignores = [
        ".DS_Store"
      ];

      delta = { enable = true; };
    };
  };
}
