{ pkgs, config, ... }:
{
  programs.gh = {
    enable = true;

    extensions = [
      pkgs.gh-dash
      config.rosetta.inputs.self.packages.${pkgs.system}.gh-poi
    ];
  };
}
