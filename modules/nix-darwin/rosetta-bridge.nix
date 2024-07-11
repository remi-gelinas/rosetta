rosetta:
{ lib, pkgs, ... }:
let
  inherit (rosetta.config.rosetta) nixpkgsConfig homeManagerModules;

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
    config = nixpkgsConfig;
  };
in
{
  _file = ./rosetta-bridge.nix;

  imports = [ ../common/colours.nix ];

  nixpkgs = {
    config = nixpkgsConfig;

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

  home-manager = {
    sharedModules = lib.attrValues homeManagerModules;
  };

  nix.registry = lib.pipe rosetta.inputs [
    (v: removeAttrs v [ "self" ])
    (lib.mapAttrs (_: flake: { inherit flake; }))
  ];

  system.configurationRevision = lib.mkDefault (self.shortRev or self.dirtyShortRev);
}
