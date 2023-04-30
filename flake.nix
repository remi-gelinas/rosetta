{
  description = "Remi's personal Nix flake.";

  inputs = {
    # Package sets
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-21.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-21.11";

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
      imports = [
        # External
        inputs.nix-pre-commit-hooks.flakeModule

        # Internal
        ./options/flake-module.nix
        ./config/flake-module.nix
        ./overlays/flake-module.nix
        ./lib/flake-module.nix
        ./home-manager/flake-module.nix
        ./darwin/flake-module.nix
      ];

      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      } @ perSystemArgs: rec {
        _module.args.pkgs = legacyPackages;

        legacyPackages = import inputs.nixpkgs-unstable {
          inherit system;
          inherit (self.nixpkgsDefaults) config;
          overlays = with self.overlays; [
            pkgs-master
            pkgs-stable
            apple-silicon
          ];
        };

        devShells = {
          default = import ./shell.nix perSystemArgs;
        };
      };

      flake = let
        inherit (self.lib) attrValues makeOverridable optionalAttrs singleton;
      in rec {
        _homeStateVersion = "23.05";

        nixpkgsDefaults = {
          config = {
            allowUnfree = true;
          };
          overlays =
            attrValues self.overlays
            ++ [
              inputs.emacs-overlay.overlays.default
            ]
            ++ singleton (
              _: prev:
                (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
                  # Sub in x86 version of packages that don't build on Apple Silicon.
                  # inherit
                  #   (final.pkgs-x86)
                  #   example
                  #   ;
                })
                // {
                  # Add other overlays here if needed.
                }
            );
        };

        primaryUserDefaults = {
          username = "rgelinas";
          fullName = "Remi Gelinas";
          email = "mail@remigelin.as";
          nixConfigDirectory = "/Users/rgelinas/.config/nixpkgs";
        };

        # Add some additional functions to `lib`.
        lib = inputs.nixpkgs-unstable.lib.extend (_: _: {
          mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;
        });

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
