rosetta:
{ lib, pkgs, ... }:
let
  inherit (rosetta.inputs)
    fenix
    nixpkgs-firefox-darwin
    nixd
    neovim
    firefox-addons
    nixpkgs-master
    self
    ;

  nixpkgs-master-unfree = import nixpkgs-master {
    inherit (pkgs) system;
    config = rosetta.config.rosetta.nixpkgsConfig;
  };
in
{
  _file = ./rosetta-bridge.nix;

  imports = with rosetta.config.rosetta.commonModules; [
    primaryUser
    colours
  ];

  config = with rosetta.config.rosetta.primaryUser; {
    nixpkgs = {
      config = rosetta.config.rosetta.nixpkgsConfig;

      overlays = [
        fenix.overlays.default
        nixpkgs-firefox-darwin.overlay
        (_: _: {
          inherit (neovim.packages.${pkgs.system}) neovim;
          inherit (nixd.packages.${pkgs.system}) nixd;
          inherit (nixpkgs-master-unfree) warp-terminal;
          inherit (rosetta.config.flake.packages.${pkgs.system}) aerospace gh-poi;

          firefox-addons = firefox-addons.packages.${pkgs.system};
        })
      ];
    };

    users.users.${username}.home = "/Users/${username}";

    home-manager = {
      sharedModules = lib.attrValues rosetta.config.rosetta.homeManagerModules;

      users.${username} = {
        inherit name gpg;

        email = lib.mkDefault email;

        home = {
          stateVersion = "23.05";
        };
      };
    };

    nix.registry =
      let
        mkRegistryFromInputs = inputs: lib.mapAttrs (_: flake: { inherit flake; }) inputs;
      in
      mkRegistryFromInputs rosetta.inputs;

    system.configurationRevision = lib.mkDefault (self.shortRev or self.dirtyShortRev);
  };
}
