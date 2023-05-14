{
  inputs = {
    # Package sets
    nixpkgs-remi.url = "github:remi-gelinas/nixpkgs/yabai-5_0_4";

    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nur.url = "github:nix-community/NUR";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Nix community overlay for Emacs
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";

    # Pre-commit hook support for Nix
    nix-pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    flake-parts,
    emacs-overlay,
    ...
  } @ inputs: let
    inherit (inputs.nixpkgs-unstable.lib) attrValues;

    parts = import ./parts;
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({config, ...}: {
      debug = true;

      imports =
        [
          inputs.nix-pre-commit-hooks.flakeModule
        ]
        ++ attrValues parts.outputs
        ++ attrValues parts.exports;

      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];

      perSystem = {system, ...}: let
        pkgs = import inputs.nixpkgs-unstable {
          inherit system;

          config = config.rosetta.nixpkgsConfig;
          overlays = [emacs-overlay.overlays.default];
        };
      in {
        _module.args.pkgs = pkgs;
        formatter = pkgs.alejandra;
      };

      flake = {
        flakeModules = parts.exports;
      };
    });
}
