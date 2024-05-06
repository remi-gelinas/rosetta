{ withSystem
, inputs
, config
,
}: {
  packages = import ./packages.nix {
    inherit withSystem;
    inherit (inputs) nixpkgs-unstable;
  };
  git = ./git.nix;
  gpg = ./gpg.nix;
  fish = import ./fish.nix;
  starship = ./starship.nix;
  gh = import ./gh.nix { inherit withSystem; };
  emacs = import ./emacs.nix { inherit withSystem; };
  wezterm = import ./wezterm.nix {
    inherit withSystem;
    inherit (inputs) nixpkgs-wezterm;
  };
  firefox = import ./firefox.nix { inherit withSystem; };
  nix = import ./nix.nix { inherit inputs; };

  home-primary-user-info = { lib, ... }: {
    options.home.user-info =
      (import config.commonModules.primaryUser { inherit lib; }).options.users.primaryUser;
  };
  primary-user-nixpkgs-config = { lib, ... }: {
    options.nixpkgsConfig =
      (import config.commonModules.nixpkgsConfig { inherit lib; }).options.nixpkgsConfig;
  };
  primary-user-colors = { lib, ... }: {
    options.colors =
      (import config.commonModules.colors { inherit lib; }).options.colors;
  };
}
