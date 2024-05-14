{
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        config,
        flake-parts-lib,
        withSystem,
        ...
      }:
      let
        mkFlakeModules =
          modules:
          builtins.mapAttrs (
            _: part: flake-parts-lib.importApply part { inherit inputs config withSystem; }
          ) modules;

        parts = import ./parts;

        outputs = mkFlakeModules parts.outputs;
        exports = mkFlakeModules parts.exports;
      in
      {
        debug = true;

        imports = [
          inputs.git-hooks.flakeModule
        ] ++ builtins.attrValues outputs ++ builtins.attrValues exports;

        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        perSystem =
          { system, ... }:
          let
            pkgs = import inputs.nixpkgs {
              inherit system;

              config = config.nixpkgsConfig;
              overlays = [ inputs.emacs-unstable.overlays.default ];
            };
          in
          {
            _module.args.pkgs = pkgs;

            formatter = pkgs.nixfmt-rfc-style;
          };

        flake.flakeModules = exports;
      }
    );

  inputs = {
    # Flake utilities ------------------------------------------------------------------------ {{{

    # Opinionated flake structure
    flake-parts.url = "github:hercules-ci/flake-parts/main";

    # Pre-commit hooks for static code analysis, formatting, conventional commits, etc.
    git-hooks.url = "github:cachix/git-hooks.nix";

    # Generate Actions matrices for Flake attributes
    nix-github-actions.url = "github:nix-community/nix-github-actions";
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

    # Nightly Emacs binaries
    emacs-unstable.url = "github:nix-community/emacs-overlay?rev=2276b94b3d43467372de17708ab3468a5821fcfc";

    # Firefox binaries for Darwin
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";

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
