rosetta: {
  packages = ./packages.nix;
  bat = ./bat.nix;
  direnv = ./direnv.nix;
  git = ./git.nix;
  gpg = ./gpg.nix;
  fish = ./fish.nix;
  starship = ./starship.nix;
  gh = ./gh.nix;
  firefox = ./firefox.nix;
  nix = ./nix.nix;
  user = ./user.nix;
  trampolines = ./trampolines.nix;
  rosetta-bridge = import ./rosetta-bridge.nix rosetta;
  aerospace = ./aerospace.nix;

  inherit (rosetta.config.rosetta.commonModules) colours nixpkgsConfig;
}
