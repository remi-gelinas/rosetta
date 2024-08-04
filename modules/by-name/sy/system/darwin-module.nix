{ local }:
{ lib, ... }:
let
  inherit (local.inputs) self;
in
{
  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;

    configurationRevision = lib.mkDefault (self.shortRev or self.dirtyShortRev);

    defaults = {
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
  };
}
