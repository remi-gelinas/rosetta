{
  self,
  inputs,
  config,
  ...
}: system: let
  pkgs = import inputs.nixpkgs-unstable {
    inherit system;
    config = config.rosetta.nixpkgsConfig;
  };
in {
  inherit system;

  primaryUser =
    config.rosetta.primaryUser
    // rec {
      username = "runner";
      fullName = "";
      email = "";
      nixConfigDirectory = "/Users/${username}/work/nixpkgs/nixpkgs";
    };

  homeModules =
    [
      {
        inherit (config.rosetta) nixpkgsConfig colors;
      }
    ]
    ++ builtins.attrValues self.homeManagerModules;

  modules =
    [
      {
        inherit (config.rosetta) nixpkgsConfig colors;
        nixpkgs.overlays = [inputs.nixpkgs-firefox-darwin.overlay];
        homebrew.enable = pkgs.lib.mkForce false;
      }
    ]
    ++ builtins.attrValues self.darwinModules;
}
