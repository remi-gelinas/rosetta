{
  inputs = {
    # Flake utilities ------------------------------------------------------------------------ {{{

    # Opinionated flake structure
    flake-parts.url = "github:hercules-ci/flake-parts";

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

    # Emacs built from source
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Binary Firefox packages for darwin systems
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";

    # All available Firefox extensions
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unfree";
    };
    # }}}
  };

  outputs = {
    flake-parts,
    emacs-overlay,
    ...
  } @ inputs: let
    parts = import ./parts;
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({config, ...}: {
      debug = true;

      imports =
        [
          inputs.nix-pre-commit-hooks.flakeModule
        ]
        ++ builtins.attrValues parts.outputs
        ++ builtins.attrValues parts.exports;

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
