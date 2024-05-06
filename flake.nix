{
  outputs = { flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } ({ config
                                                 , flake-parts-lib
                                                 , withSystem
                                                 , ...
                                                 }:
      let
        mkFlakeModules = modules:
          builtins.mapAttrs
            (_: part:
              flake-parts-lib.importApply part {
                inherit inputs config withSystem;
              })
            modules;

        parts = import ./parts;

        outputs = mkFlakeModules parts.outputs;
        exports = mkFlakeModules parts.exports;
      in
      {
        debug = true;

        imports =
          [
            inputs.nix-pre-commit-hooks.flakeModule
          ]
          ++ builtins.attrValues outputs
          ++ builtins.attrValues exports;

        systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];

        perSystem = { system, ... }:
          let
            pkgs = import inputs.nixpkgs-unstable {
              inherit system;

              config = config.nixpkgsConfig;
            };
          in
          {
            _module.args.pkgs = pkgs;

            formatter = pkgs.nixpkgs-fmt;
          };

        flake.flakeModules = exports;
      });

  inputs = {
    # Flake utilities ------------------------------------------------------------------------ {{{

    # Opinionated flake structure
    flake-parts.url = "github:hercules-ci/flake-parts/main";

    # Pre-commit hooks for static code analysis, formatting, conventional commits, etc.
    nix-pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    # Generate Actions matrices for Flake attributes
    nix-github-actions.url = "github:nix-community/nix-github-actions";
    # }}}

    # Package sets --------------------------------------------------------------------------- {{{
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree/main";

    nixpkgs-wezterm.url = "github:NixOS/nixpkgs?rev=9cfaa8a1a00830d17487cb60a19bb86f96f09b27";
    # }}}

    # System configuration ------------------------------------------------------------------- {{{

    darwin.url = "github:LnL7/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager?rev=19c6a4081b14443420358262f8416149bd79561a";
    # }}}

    # Other dependencies --------------------------------------------------------------------- {{{

    # Nightly Nix binaries
    nix.url = "github:NixOS/nix/2.22.0";

    # Nightly Emacs binaries
    emacs-unstable.url = "github:nix-community/emacs-overlay?rev=2276b94b3d43467372de17708ab3468a5821fcfc";

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

    nvfetcher.url = "github:berberman/nvfetcher";
    # }}}
  };
}
