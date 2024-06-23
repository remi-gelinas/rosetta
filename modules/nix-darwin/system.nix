{ lib, config, ... }:
let
  inherit (config.rosetta.inputs) self;
in
{
  system.configurationRevision = lib.mkDefault (self.shortRev or self.dirtyShortRev);

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system.defaults = {
    # Finder
    finder = {
      # Do not show icons on the desktop
      CreateDesktop = false;
    };

    CustomSystemPreferences = {
      "NSGlobalDomain" = {
        "NSWindowShouldDragOnGesture" = "YES";
      };
    };
  };
}
