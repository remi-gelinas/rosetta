{
  local,
  inputs,
  config,
}:
{
  packages = import ./packages.nix inputs;
  bat = import ./bat.nix inputs;
  direnv = import ./direnv.nix inputs;
  git = import ./git.nix inputs;
  gpg = import ./gpg.nix inputs;
  fish = import ./fish.nix inputs;
  starship = import ./starship.nix inputs;
  gh = import ./gh.nix local;
  wezterm = import ./wezterm.nix inputs;
  firefox = import ./firefox.nix inputs;
  nix = import ./nix.nix inputs;
  nixpkgs = import ./nixpkgs.nix inputs;
  user = ./user.nix;

  inherit (config.rosetta.commonModules) nixpkgsConfig colours;
}
