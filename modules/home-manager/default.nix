inputs: {
  packages = import ./packages.nix inputs;
  bat = import ./bat.nix inputs;
  direnv = import ./direnv.nix inputs;
  git = import ./git.nix inputs;
  gpg = import ./gpg.nix inputs;
  fish = import ./fish.nix inputs;
  starship = import ./starship.nix inputs;
  gh = import ./gh.nix inputs;
  wezterm = import ./wezterm.nix inputs;
  firefox = import ./firefox.nix inputs;
  nix = import ./nix.nix inputs;

  home-primary-user-info =
    { lib, ... }:
    {
      options.home.user-info =
        (import inputs.self.commonModules.primaryUser { inherit lib; }).options.users.primaryUser;
    };
  primary-user-nixpkgs-config =
    { lib, ... }:
    {
      options.nixpkgsConfig =
        (import inputs.self.commonModules.nixpkgsConfig { inherit lib; }).options.nixpkgsConfig;
    };
  primary-user-colors =
    { lib, ... }:
    {
      options.colors = (import inputs.self.commonModules.colors { inherit lib; }).options.colors;
    };
}
