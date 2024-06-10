{ pkgs, rosetta, ... }:
{
  programs.gh = {
    enable = true;

    extensions = [
      pkgs.gh-dash
      (rosetta.withSystem pkgs.system ({ config, ... }: config.packages.gh-poi))
    ];
  };
}
