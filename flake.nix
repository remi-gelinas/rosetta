{
  inputs = {
    # Flake utilities ------------------------------------------------------------------------ {{{

    # Opinionated flake structure
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Flake system support
    systems.url = "github:nix-systems/default";

    # Static Nix code analysis and formatting
    nix-pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # }}}

    # Package sets --------------------------------------------------------------------------- {{{

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";

    # My personal nixpkgs fork
    nixpkgs-remi.url = "github:remi-gelinas/nixpkgs/yabai-5_0_4";
    # }}}

    # System configuration ------------------------------------------------------------------- {{{

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # }}}

    # Other dependencies --------------------------------------------------------------------- {{{

    emacs-unstable = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unfree";
    };
    # }}}
  };

  outputs = {
    flake-parts,
    systems,
    ...
  } @ inputs: let
    parts = import ./parts;
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({
      config,
      flake-parts-lib,
      withSystem,
      ...
    }: let
      inherit (flake-parts-lib) importApply;
    in {
      debug = true;

      imports =
        [
          inputs.nix-pre-commit-hooks.flakeModule
        ]
        ++ map (part:
          importApply part {
            inherit inputs config withSystem;
          }) (builtins.attrValues parts);

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

      flake = {
        flakeModules = parts;
      };
    });
}
