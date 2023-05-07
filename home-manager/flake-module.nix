{self, ...} @ args: {
  flake.homeManagerModules = {
    packages = ./packages.nix;
    git = ./git.nix;
    gpg = ./gpg.nix;
    fish = ./fish.nix;
    starship = ./starship.nix;
    gh = import ./gh.nix args;
    emacs = import ./emacs.nix args;

    # Custom modules
    home-user-info = {lib, ...}: {
      options.home.user-info =
        (import self.darwinModules.users-primaryUser {inherit lib;}).options.users.primaryUser;
    };
  };
}
