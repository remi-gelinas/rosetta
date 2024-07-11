rosetta: {
  aerospace = ./programs/aerospace.nix;
  bat = ./bat.nix;
  direnv = ./direnv.nix;
  firefox = ./firefox.nix;
  fish = ./fish.nix;
  gh = ./gh.nix;
  git = ./git.nix;
  packages = ./packages.nix;
  rosetta-bridge = import ./rosetta-bridge.nix rosetta;
  starship = ./starship.nix;
  thefuck = ./thefuck.nix;
  trampolines = ./trampolines.nix;
  zoxide = ./zoxide.nix;
}
