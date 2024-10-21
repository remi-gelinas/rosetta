{
  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;

    defaults = {
      LaunchServices.LSQuarantine = false; # Disable app quarantining

      finder = {
        CreateDesktop = false; # Do not show icons on the desktop
        AppleShowAllExtensions = true; # Show all file extensions
        FXEnableExtensionChangeWarning = false; # Disable Warning for changing extension
        FXPreferredViewStyle = "icnv"; # Change the default finder view. “icnv” = Icon view
        QuitMenuItem = true; # Allow qutting Finder
        ShowPathbar = true; # Show full path at bottom
      };

      NSGlobalDomain = {
        NSAutomaticWindowAnimationsEnabled = false; # Disable opening and closing animation

        NSDocumentSaveNewDocumentsToCloud = false; # Disable auto save text files to iCloud (TextEdit)

        NSAutomaticCapitalizationEnabled = false; # Disable auto capitalization
        NSAutomaticSpellingCorrectionEnabled = false; # Disable spell checker
        NSAutomaticPeriodSubstitutionEnabled = false; # Disable adding . after pressing space twice

        NSAutomaticDashSubstitutionEnabled = false; # Disable "smart" dash substitution
        NSAutomaticQuoteSubstitutionEnabled = false; # No "smart" quote substitution

      };

      CustomSystemPreferences."NSGlobalDomain"."NSWindowShouldDragOnGesture" = "YES";
    };
  };
}
