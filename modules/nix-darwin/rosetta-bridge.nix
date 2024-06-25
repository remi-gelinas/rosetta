rosetta:
{ lib, ... }:
with lib;
{
  _file = ./rosetta-bridge.nix;

  options.rosetta = {
    inputs = with types; mkOption { type = attrsOf unspecified; };
  };

  config = with rosetta.config.rosetta.primaryUser; {
    rosetta.inputs = rosetta.inputs;

    nixpkgs.config = rosetta.config.rosetta.nixpkgsConfig;

    nix.registry.nixpkgs.flake = rosetta.inputs.nixpkgs;

    users.users.${username}.home = "/Users/${username}";

    home-manager = {
      sharedModules = attrValues rosetta.config.rosetta.homeManagerModules;

      users.${username} = {
        inherit name gpg;

        email = mkDefault email;

        home = {
          stateVersion = "23.05";
        };
      };
    };
  };
}
