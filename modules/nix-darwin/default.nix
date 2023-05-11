args: {
  bootstrap = ./bootstrap.nix;
  defaults = ./defaults.nix;
  general = ./general.nix;
  homebrew = ./homebrew.nix;
  yabai = import ./yabai.nix args;
  touchID = ./touch-id.nix;

  users-primaryUser = ../common/primary-user.nix;
  nixpkgs-config = ../common/nixpkgs-config.nix;
}
