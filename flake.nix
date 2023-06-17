{
  outputs = {
    flake-parts,
    systems,
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

      systems = import systems;

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
    # }}}

    # Package sets --------------------------------------------------------------------------- {{{
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree/main";
    # }}}

    # System configuration ------------------------------------------------------------------- {{{

    darwin.url = "github:LnL7/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager?rev=54a9d6456eaa6195998a0f37bdbafee9953ca0fb";
    # }}}

    # Other dependencies --------------------------------------------------------------------- {{{

    # Nightly Nix binaries
    nix.url = "github:NixOS/nix?rev=61ddfa154bcfa522819781d23e40e984f38dfdeb";

    # Nightly Emacs binaries
    emacs-unstable = {
      url = "github:nix-community/emacs-overlay/master";

      # https://github.com/nix-community/emacs-overlay/issues/329
      inputs.nixpkgs.follows = "nixpkgs-master";
    };

    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin/main";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions/master?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unfree";
    };
    # }}}
  };
}
