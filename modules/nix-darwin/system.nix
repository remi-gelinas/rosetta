{ self, ... }:
{ lib, ... }:
{
  _file = ./system.nix;

  system.configurationRevision = lib.mkDefault (self.rev or self.dirtyRev);

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system.defaults = {
    # Finder
    finder = {
      # Do not show icons on the desktop
      CreateDesktop = false;
    };
  };
}
