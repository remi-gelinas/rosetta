{ pkgs, ... }:
{
  # Make Fish the default shell
  programs.fish = {
    enable = true;

    useBabelfish = true;
    babelfishPackage = pkgs.babelfish;
  };

  environment = {
    variables.SHELL = "${pkgs.fish}/bin/fish";
    shells = with pkgs; [ fish ];
  };
}
