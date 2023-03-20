{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;

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
  };
}
