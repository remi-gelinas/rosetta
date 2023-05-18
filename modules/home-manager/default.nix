{self, ...} @ args: {
  packages = import ./packages.nix args;
  git = ./git.nix;
  gpg = ./gpg.nix;
  fish = import ./fish.nix args;
  starship = ./starship.nix;
  gh = import ./gh.nix args;
  emacs = import ./emacs.nix args;
  wezterm = import ./wezterm.nix args;
  firefox = import ./firefox.nix args;

  home-primary-user-info = {lib, ...}: {
    options.home.user-info =
      (import "${self}/modules/common/primary-user.nix" {inherit lib;}).options.users.primaryUser;
  };
  primary-user-nixpkgs-config = {lib, ...}: {
    options.nixpkgsConfig =
      (import "${self}/modules/common/nixpkgs-config.nix" {inherit lib;}).options.nixpkgsConfig;
  };
  primary-user-colors = {lib, ...}: {
    options.colors =
      (import "${self}/modules/common/colors.nix" {inherit lib;}).options.colors;
  };
}
