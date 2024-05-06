{ nixpkgs-unstable
, nixpkgs-firefox-darwin
, config
,
}: system:
let
  pkgs = import nixpkgs-unstable {
    inherit system;
    config = config.nixpkgsConfig;
  };
in
{
  inherit system;

  primaryUser =
    config.primaryUser
    // rec {
      username = "runner";
      fullName = "";
      email = "";
      nixConfigDirectory = "/Users/${username}/work/nixpkgs/nixpkgs";
    };

  homeModules =
    [
      {
        inherit (config) nixpkgsConfig colors;
      }
    ]
    ++ builtins.attrValues config.homeManagerModules;

  modules =
    [
      {
        inherit (config) nixpkgsConfig colors;
        nixpkgs.overlays = [ nixpkgs-firefox-darwin.overlay ];
        homebrew.enable = pkgs.lib.mkForce false;
      }
    ]
    ++ builtins.attrValues config.darwinModules;
}
