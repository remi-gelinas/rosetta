{
  outputs = {
    flake-parts,
    # systems,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      config,
      flake-parts-lib,
      withSystem,
      ...
    }: let
      mkFlakeModules = modules:
        builtins.mapAttrs (_: part:
          flake-parts-lib.importApply part {
            inherit inputs config withSystem;
          })
        modules;

      parts = import ./parts;

      outputs = mkFlakeModules parts.outputs;
      exports = mkFlakeModules parts.exports;
    in {
      debug = true;

      imports =
        [
          inputs.nix-pre-commit-hooks.flakeModule
        ]
        ++ builtins.attrValues outputs
        ++ builtins.attrValues exports;

      # systems = import systems;
      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];

      perSystem = {system, ...}: let
        pkgs = import inputs.nixpkgs-unstable {
          inherit system;
          config = config.nixpkgsConfig;
        };
      in {
        _module.args.pkgs = pkgs;
        formatter = pkgs.alejandra;
      };

      flake.flakeModules = exports;
    });

  inputs = {
    # Flake utilities ------------------------------------------------------------------------ {{{

    # Opinionated flake structure
    flake-parts.url = "github:hercules-ci/flake-parts/main";

    # Flake system support
    systems.url = "github:nix-systems/default/main";

    # Pre-commit hooks for static code analysis, formatting, conventional commits, etc.
    nix-pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix/master";

    # Generate Actions matrices for Flake attributes
    nix-github-actions.url = "github:nix-community/nix-github-actions";
    # }}}

    # Package sets --------------------------------------------------------------------------- {{{
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree/main";

    nixpkgs-wezterm.url = "github:NixOS/nixpkgs?rev=efd23a1c9ae8c574e2ca923c2b2dc336797f4cc4";
    # }}}

    # System configuration ------------------------------------------------------------------- {{{

    darwin.url = "github:LnL7/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager?rev=19c6a4081b14443420358262f8416149bd79561a";
    # }}}

    # Other dependencies --------------------------------------------------------------------- {{{

    # Nightly Nix binaries
    nix.url = "github:NixOS/nix";

    # Nightly Emacs binaries
    emacs-unstable.url = "github:nix-community/emacs-overlay";

    # Firefox binaries for Darwin
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin/main";

    # Firefox extensions
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions/master?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unfree";
    };

    nixd.url = "github:nix-community/nixd";
    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };
    # }}}
  };
}
