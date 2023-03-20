{ config, lib, pkgs, ... }:

{
  programs.gh = {
    enable = true;

    extensions = [
      pkgs.gh-dash
    ];
  };
}
