{
  description = "Remi's personal Nix flake.";

  inputs = {
    # Package sets
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.11";

    # NUR
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

    # Pre-commit hook support for Nix
    nix-pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    darwin,
    flake-parts,
    emacs-overlay,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;

      imports = [
        # External
        inputs.flake-parts.flakeModules.easyOverlay
        inputs.nix-pre-commit-hooks.flakeModule

        # Internal
        ./config/flake-module.nix
        ./overlays/flake-module.nix
        ./lib/flake-module.nix
        ./configurations/flake-module.nix
        ./devshells/flake-module.nix
        ./home-manager/flake-module.nix
        ./darwin/flake-module.nix
      ];

      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: let
        inherit (inputs.nixpkgs-stable.lib) attrValues;
      in {
        _module.args.pkgs = import inputs.nixpkgs-stable {
          inherit system;
          inherit (self.nixpkgsDefaults) config;
          overlays = [self.overlays.default emacs-overlay.overlays.default];
        };
      };

      flake = {
        flakeModules = {
          options = ./options/flake-module.nix;
          config = ./config/flake-module.nix;
          overlays = ./overlays/flake-module.nix;
          lib = ./lib/flake-module.nix;
          home-manager = ./home-manager/flake-module.nix;
          darwin = ./darwin/flake-module.nix;
        };

        nixpkgsDefaults = {
          config = {
            allowUnfree = true;
          };
        };

        # System configurations ------------------------------------------------------------------ {{{

        # darwinConfigurations = {
        #   # Minimal macOS configurations to bootstrap systems
        #   bootstrap-x86 = makeOverridable darwin.lib.darwinSystem {
        #     system = "x86_64-darwin";
        #     modules = [./darwin/bootstrap.nix {nixpkgs = nixpkgsDefaults;}];
        #   };
        #   bootstrap-arm = self.darwinConfigurations.bootstrap-x86.override {
        #     system = "aarch64-darwin";
        #   };

        #   # My Apple Silicon system config
        #   M1 = let
        #     system = "aarch64-darwin";
        #   in
        #     makeOverridable self.lib.mkDarwinSystem (primaryUserDefaults
        #       // rec {
        #         homeStateVersion = _homeStateVersion;
        #         inherit system;

        #         modules =
        #           attrValues self.darwinModules
        #           ++ singleton {
        #             nixpkgs = nixpkgsDefaults;
        #             nix.registry.my.flake = inputs.self;
        #           };

        #         homeModules = (attrValues self.homeManagerModules) ++ [nur-no-pkgs.repos.rycee.hmModules.emacs-init];
        #       });

        #   # My Apple Silicon config, built for inferior laptops
        #   Intel = let
        #     system = "x86_64-darwin";

        #     nur-no-pkgs = import inputs.nur {
        #       nurpkgs = import inputs.nixpkgs-unstable {inherit system;};
        #     };
        #   in
        #     self.darwinConfigurations.M1.override {
        #       system = "x86_64-darwin";
        #       homeModules = (attrValues self.homeManagerModules) ++ [nur-no-pkgs.repos.rycee.hmModules.emacs-init];
        #     };

        #   # Config with small modifications needed/desired for CI with GitHub workflow
        #   githubCI = self.darwinConfigurations.M1.override {
        #     system = "x86_64-darwin";
        #     username = "runner";
        #     nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
        #     extraModules = singleton {homebrew.enable = self.lib.mkForce false;};
        #   };
        # };
        # }}}
      };
    };
}
