args: {
  flake.darwinModules = {
    # Darwin
    bootstrap = import ./bootstrap.nix args;
    defaults = import ./defaults.nix args;
    general = import ./general.nix args;
    homebrew = import ./homebrew.nix args;
    yabai = import ./yabai.nix args;
    touchID = import ./touch-id.nix args;

    # Common
    users-primaryUser = ../common/primary-user.nix;
    nixpkgs-config = ../common/nixpkgs-config.nix;
  };
}
