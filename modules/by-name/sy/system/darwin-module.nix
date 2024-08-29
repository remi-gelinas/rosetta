{
  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;

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
