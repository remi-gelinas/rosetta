{ config, lib, pkgs, ... }:

{
  programs.fish.enable = true;

  programs.fish.shellAliases = with pkgs; {
    ":q" = "exit";
    cat = "${bat}/bin/bat";
    ls = "${exa}/bin/exa";
  };

  programs.fish.shellInit = ''
    set -U fish_term24bit 1
  '';

  programs.fish.interactiveShellInit = ''
    set -g fish_greeting ""
  '';
}
