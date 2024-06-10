rosetta: {
  nix = ./nix.nix;
  system = ./system.nix;
  shells = ./shells.nix;
  gpg = ./gpg.nix;
  homebrew = ./homebrew.nix;
  yabai = ./yabai.nix;
  touchID = ./touch-id.nix;
  firefox = ./firefox.nix;
  sketchybar = ./services/sketchybar.nix;
  homeManager = ./home-manager.nix;
  caches = ./caches;
  nixpkgs = ./nixpkgs.nix;
  trampolines = ./trampolines.nix;
  rosetta-bridge = import ./rosetta-bridge.nix rosetta;

  inherit (rosetta.config.rosetta.commonModules) primaryUser colours;
}
