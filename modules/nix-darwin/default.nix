{ inputs, config }:
{
  nix = import ./nix.nix inputs;
  system = import ./system.nix inputs;
  shells = import ./shells.nix inputs;
  gpg = import ./gpg.nix inputs;
  homebrew = import ./homebrew.nix inputs;
  yabai = import ./yabai.nix inputs;
  touchID = import ./touch-id.nix inputs;
  firefox = import ./firefox.nix inputs;
  sketchybar = import ./services/sketchybar.nix inputs;
  homeManager = import ./home-manager.nix inputs;
  caches = ./caches;
  nixpkgs = import ./nixpkgs.nix inputs;

  inherit (config.rosetta.commonModules) primaryUser nixpkgsConfig colours;
}
