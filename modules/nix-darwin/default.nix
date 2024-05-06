localFlake: {
  bootstrap = import ./bootstrap.nix { inherit (localFlake) withSystem inputs; };
  defaults = ./defaults.nix;
  gpg = ./gpg.nix;
  homebrew = ./homebrew.nix;
  yabai = import ./yabai.nix { inherit (localFlake) withSystem; };
  touchID = ./touch-id.nix;
  firefox = ./firefox.nix;
  sketchybar = ./services/sketchybar.nix;
  emacs = import ./services/emacs.nix { inherit (localFlake) withSystem; };

  users-primaryUser = localFlake.config.commonModules.primaryUser;
  nixpkgs-config = localFlake.config.commonModules.nixpkgsConfig;
  inherit (localFlake.config.commonModules) colors;
}
