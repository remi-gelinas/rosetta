{self, ...} @ args: {
  bootstrap = ./bootstrap.nix;
  defaults = ./defaults.nix;
  gpg = ./gpg.nix;
  homebrew = ./homebrew.nix;
  yabai = import ./yabai.nix args;
  touchID = ./touch-id.nix;
  firefox = ./firefox.nix;
  sketchybar = ./services/sketchybar.nix;
  emacs = import ./services/emacs.nix args;

  users-primaryUser = "${self}/modules/common/primary-user.nix";
  nixpkgs-config = "${self}/modules/common/nixpkgs-config.nix";
  colors = "${self}/modules/common/colors.nix";
}
