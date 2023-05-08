args: {
  flake.homeManagerModules = {
    # Home-manager
    packages = import ./packages.nix args;
    git = ./git.nix;
    gpg = ./gpg.nix;
    fish = ./fish.nix;
    starship = ./starship.nix;
    gh = import ./gh.nix args;
    emacs = import ./emacs.nix args;

    # Common
    home-primary-user-info = {lib, ...}: {
      options.home.user-info =
        (import ../common/primary-user.nix {inherit lib;}).options.users.primaryUser;
    };
  };
}
