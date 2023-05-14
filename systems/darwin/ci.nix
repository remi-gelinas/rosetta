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

  nur = import inputs.nur {
    inherit pkgs;
    nurpkgs = pkgs;
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
      nur.repos.rycee.hmModules.emacs-init
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
