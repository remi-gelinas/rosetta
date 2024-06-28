rosetta: {
  nix = ./nix.nix;
  system = ./system.nix;
  shells = ./shells.nix;
  gpg = ./gpg.nix;
  homebrew = ./homebrew.nix;
  touchID = ./touch-id.nix;
  firefox = ./firefox.nix;
  sketchybar = ./sketchybar.nix;
  homeManager = ./home-manager.nix;
  caches = ./caches;
  trampolines = ./trampolines.nix;
  rosetta-bridge = import ./rosetta-bridge.nix rosetta;
}
