{
  config,
  lib,
  pkgs,
  ...
}: {
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

      delta = {enable = true;};

      extraConfig = {
        merge = {
          tool = "nvimdiff1";
          conflictStyle = "zdiff3";
          prompt = false;
        };
      };

      includes = [
        {
          condition = "gitdir:${config.home.homeDirectory}/Documents/Workspace/Momentive/";

          contents = {
            user = {
              name = "Remi Gelinas";
              email = "rgelinas@momentive.ai";
            };
          };
        }
      ];
    };
  };
}
