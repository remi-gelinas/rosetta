inputs: {
  nix = import ./nix.nix inputs;
  system = import ./system.nix inputs;
  shells = import ./shells.nix inputs;
  gpg = import ./gpg.nix inputs;
  homebrew = import ./homebrew.nix inputs;
  yabai = import ./yabai.nix inputs;
  touchID = import ./touch-id.nix inputs;
  firefox = import ./firefox.nix inputs;
  sketchybar = import ./services/sketchybar.nix inputs;
  home-manager = import ./home-manager.nix inputs;

  users-primaryUser = inputs.self.commonModules.primaryUser;
  nixpkgs-config = inputs.self.commonModules.nixpkgsConfig;

  inherit (inputs.self.commonModules) colors;
}
