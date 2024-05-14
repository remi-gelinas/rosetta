localFlake: {
  nix = import ./nix.nix { inherit (localFlake) withSystem inputs; };
  system = ./system.nix;
  shells = ./shells.nix;
  gpg = ./gpg.nix;
  homebrew = ./homebrew.nix;
  yabai = ./yabai.nix;
  touchID = ./touch-id.nix;
  firefox = ./firefox.nix;
  sketchybar = ./services/sketchybar.nix;
  emacs = import ./services/emacs.nix { inherit (localFlake) withSystem; };
  home-manager = ./home-manager.nix;

  users-primaryUser = localFlake.config.commonModules.primaryUser;
  nixpkgs-config = localFlake.config.commonModules.nixpkgsConfig;

  inherit (localFlake.config.commonModules) colors;
}
