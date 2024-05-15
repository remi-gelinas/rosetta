{
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        flake-parts-lib,
        withSystem,
        config,
        ...
      }:
      let
        parts = import ./parts {
          inherit (flake-parts-lib) importApply;
          inherit withSystem config;
        };
      in
      {
        debug = true;

        imports = builtins.attrValues parts;

        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        flake.flakeModules = parts;
      }
    );

  inputs = {
    # Flake utilities ------------------------------------------------------------------------ {{{

    # Opinionated flake structure
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Pre-commit hooks for static code analysis, formatting, conventional commits, etc.
    git-hooks.url = "github:cachix/git-hooks.nix";

    # Generate Actions matrices for Flake attributes
    github-actions.url = "github:nix-community/nix-github-actions";
    # }}}

    # Package sets --------------------------------------------------------------------------- {{{
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wezterm.url = "github:NixOS/nixpkgs?rev=9cfaa8a1a00830d17487cb60a19bb86f96f09b27";
    # }}}

    # System configuration ------------------------------------------------------------------- {{{

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # Other dependencies --------------------------------------------------------------------- {{{

    # Nightly Nix binaries
    nix.url = "github:NixOS/nix/2.22.0";

    # Firefox binaries for Darwin
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";

    # Firefox extensions
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions/master?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unfree";
    };

    nixd.url = "github:nix-community/nixd";
    # }}}
  };
}
