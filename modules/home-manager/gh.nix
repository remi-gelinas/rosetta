local:
{ pkgs, ... }:
{
  _file = ./gh.nix;

  programs.gh = {
    enable = true;

    extensions = [
      pkgs.gh-dash
      (local.withSystem pkgs.system ({ config, ... }: config.packages.gh-poi))
    ];
  };
}
