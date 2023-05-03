_: {
  flake.darwinModules = {
    # Configs
    bootstrap = ./bootstrap.nix;
    defaults = ./defaults.nix;
    general = ./general.nix;
    homebrew = ./homebrew.nix;
    yabai = ./yabai.nix;
    touchID = ./touch-id.nix;

    # Modules
    users-primaryUser = ./modules/users.nix;
  };
}
