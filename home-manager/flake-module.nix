args: {
  flake.homeManagerModules = {
    packages = import ./packages.nix args;
    git = ./git.nix;
    gpg = ./gpg.nix;
    fish = ./fish.nix;
    starship = ./starship.nix;
    gh = import ./gh.nix args;
    emacs = import ./emacs.nix args;
    wezterm = ./wezterm.nix;

    home-primary-user-info = {lib, ...}: {
      options.home.user-info =
        (import ../common/primary-user.nix {inherit lib;}).options.users.primaryUser;
    };
    primary-user-nixpkgs-config = {lib, ...}: {
      options.nixpkgsConfig =
        (import ../common/nixpkgs-config.nix {inherit lib;}).options.nixpkgsConfig;
    };
  };
}
