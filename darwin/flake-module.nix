args: {
  flake.darwinModules = {
    # Configs
    bootstrap = import ./bootstrap.nix args;
    defaults = import ./defaults.nix args;
    general = import ./general.nix args;
    homebrew = import ./homebrew.nix args;
    yabai = import ./yabai.nix args;
    touchID = import ./touch-id.nix args;

    # Modules
    users-primaryUser = ./users.nix;
  };
}
