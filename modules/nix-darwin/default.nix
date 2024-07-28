rosetta: {
  aerospace = ./programs/aerospace.nix;
  atuin-daemon = ./services/atuin-daemon.nix;
  caches = ./caches;
  firefox = ./firefox.nix;
  homeManager = ./home-manager.nix;
  homebrew = ./homebrew.nix;
  nix = ./nix.nix;
  rosetta-bridge = import ./rosetta-bridge.nix rosetta;
  shells = ./shells.nix;
  sketchybar = ./sketchybar.nix;
  system = ./system.nix;
  touchID = ./touch-id.nix;
  trampolines = ./trampolines.nix;
  users = ./users.nix;
}
