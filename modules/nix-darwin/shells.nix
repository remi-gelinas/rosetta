_:
{ pkgs, ... }:
{
  _file = ./shells.nix;

  # Shell configuration
  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  # Make Fish the default shell
  programs.fish = {
    enable = true;

    useBabelfish = true;
    babelfishPackage = pkgs.babelfish;
  };

  environment.variables.SHELL = "${pkgs.fish}/bin/fish";
}
