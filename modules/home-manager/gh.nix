{ self, ... }:
{ pkgs, ... }:
{
  programs.gh = {
    enable = true;

    extensions = [
      pkgs.gh-dash
      self.packages.${pkgs.system}.gh-poi
    ];
  };
}
