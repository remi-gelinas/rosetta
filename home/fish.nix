{pkgs, ...}: {
  programs.fish = {
    enable = true;

    plugins = with pkgs; [
      {
        name = "bass";
        inherit (fishPlugins.bass) src;
      }
    ];

    shellAliases = with pkgs; {
      cat = "${bat}/bin/bat";
      ls = "${exa}/bin/exa";
      find = "${fd}/bin/fd";
    };

    shellAbbrs = {
      ":q" = "exit";
    };

    shellInit = ''
      set -U fish_term24bit 1
    '';

    interactiveShellInit = ''
      set -g fish_greeting ""
      ${pkgs.thefuck}/bin/thefuck --alias | source
    '';

    functions = {
      "clear-iam" = ''
        bass (aws-sso eval --sso=mntv-$argv[1] --clear)
      '';

      "switch-role" = ''
        clear-iam $argv[1]
        ${pkgs.aws-sso-cli}/bin/aws-sso exec --sso=mntv-$argv[1]
      '';
    };
  };
}
