{self, ...}: {
  flake.homeManagerModules = {
    packages = ./packages.nix;
    git = ./git.nix;
    fish = ./fish.nix;
    starship = ./starship.nix;
    gh = ./gh.nix;
    emacs = ./emacs.nix;

    # Custom modules
    home-user-info = {lib, ...}: {
      options.home.user-info =
        (import self.darwinModules.users-primaryUser {inherit lib;}).options.users.primaryUser;
    };
  };
}
