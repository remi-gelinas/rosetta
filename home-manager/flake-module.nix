{self, ...}: {
  flake.homeManagerModules = {
    # Configs
    general = ./general.nix;
    packages = ./packages.nix;
    git = ./git.nix;
    fish = ./fish.nix;
    starship = ./starship.nix;
    gh = ./gh.nix;
    emacs = ./emacs.nix;

    # Custom modules
    home-user-info = {lib, ...}: {
      options.home.user-info =
        (self.darwinModules.users-primaryUser {inherit lib;}).options.users.primaryUser;
    };
  };
}
