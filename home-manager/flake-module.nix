{self, ...} @ args: {
  flake.homeManagerModules = {
    packages = import ./packages.nix args;
    git = import ./git.nix args;
    fish = ./fish.nix;
    starship = ./starship.nix;
    gh = ./gh.nix;
    emacs = import ./emacs.nix args;

    # Custom modules
    home-user-info = {lib, ...}: {
      options.home.user-info =
        (import self.darwinModules.users-primaryUser {inherit lib;}).options.users.primaryUser;
    };
  };
}
