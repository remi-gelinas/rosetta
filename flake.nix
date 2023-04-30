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

    # Other sources
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

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
    flake-utils,
    flake-parts,
    emacs-overlay,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.nix-pre-commit-hooks.flakeModule
      ];

      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
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

        pre-commit = {
          settings.hooks = {
            alejandra.enable = true;
            deadnix.enable = true;
            statix.enable = true;
          };
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

        # Overlays --------------------------------------------------------------------------------{{{

        overlays = {
          # Overlays to add different versions `nixpkgs` into package set
          pkgs-master = _: prev: {
            pkgs-master = import inputs.nixpkgs-master {
              inherit (prev.stdenv) system;
              inherit (nixpkgsDefaults) config;
            };
          };
          pkgs-stable = _: prev: {
            pkgs-stable = import inputs.nixpkgs-stable {
              inherit (prev.stdenv) system;
              inherit (nixpkgsDefaults) config;
            };
          };
          pkgs-unstable = _: prev: {
            pkgs-unstable = import inputs.nixpkgs-unstable {
              inherit (prev.stdenv) system;
              inherit (nixpkgsDefaults) config;
            };
          };
          apple-silicon = _: prev:
            optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
              # Add access to x86 packages system is running Apple Silicon
              pkgs-x86 = import inputs.nixpkgs-unstable {
                system = "x86_64-darwin";
                inherit (nixpkgsDefaults) config;
              };
            };

          custom-emacs = import ./overlays/emacs.nix;
          utils = import ./overlays/utils.nix;
          fonts = import ./overlays/fonts.nix;
          ssh-keys = import ./overlays/ssh-keys.nix;
          colors = import ./overlays/colors.nix;
          pkgs = import ./overlays/packages.nix;
        };
        # }}}

        # Modules -------------------------------------------------------------------------------- {{{

        darwinModules = {
          # Configs
          remi-bootstrap = import ./darwin/bootstrap.nix;
          remi-defaults = import ./darwin/defaults.nix;
          remi-general = import ./darwin/general.nix;
          remi-homebrew = import ./darwin/homebrew.nix;
          remi-yabai = import ./darwin/yabai.nix;

          # Custom modules
          users-primaryUser = import ./modules/darwin/users.nix;
        };

        homeManagerModules = {
          # Configs
          remi-general = import ./home/general.nix;
          remi-packages = import ./home/packages.nix;
          remi-git = import ./home/git.nix;
          remi-kitty = import ./home/kitty.nix;
          remi-fish = import ./home/fish.nix;
          remi-starship = import ./home/starship.nix;
          remi-gh = import ./home/gh.nix;
          remi-emacs = import ./home/emacs.nix;

          # Custom modules
          home-user-info = {lib, ...}: {
            options.home.user-info =
              (self.darwinModules.users-primaryUser {inherit lib;}).options.users.primaryUser;
          };
        };
        # }}}

        # System configurations ------------------------------------------------------------------ {{{

        darwinConfigurations = {
          # Minimal macOS configurations to bootstrap systems
          bootstrap-x86 = makeOverridable darwin.lib.darwinSystem {
            system = "x86_64-darwin";
            modules = [./darwin/bootstrap.nix {nixpkgs = nixpkgsDefaults;}];
          };
          bootstrap-arm = self.darwinConfigurations.bootstrap-x86.override {
            system = "aarch64-darwin";
          };

          # My Apple Silicon system config
          M1 = let
            system = "aarch64-darwin";

            nur-no-pkgs = import inputs.nur {
              nurpkgs = import inputs.nixpkgs-unstable {inherit system;};
            };
          in
            makeOverridable self.lib.mkDarwinSystem (primaryUserDefaults
              // rec {
                homeStateVersion = _homeStateVersion;
                inherit system;

                modules =
                  attrValues self.darwinModules
                  ++ singleton {
                    nixpkgs = nixpkgsDefaults;
                    nix.registry.my.flake = inputs.self;
                  };

                homeModules = (attrValues self.homeManagerModules) ++ [nur-no-pkgs.repos.rycee.hmModules.emacs-init];
              });

          # My Apple Silicon config, built for inferior laptops
          Intel = let
            system = "x86_64-darwin";

            nur-no-pkgs = import inputs.nur {
              nurpkgs = import inputs.nixpkgs-unstable {inherit system;};
            };
          in
            self.darwinConfigurations.M1.override {
              system = "x86_64-darwin";
              homeModules = (attrValues self.homeManagerModules) ++ [nur-no-pkgs.repos.rycee.hmModules.emacs-init];
            };

          # Config with small modifications needed/desired for CI with GitHub workflow
          githubCI = self.darwinConfigurations.M1.override {
            system = "x86_64-darwin";
            username = "runner";
            nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
            extraModules = singleton {homebrew.enable = self.lib.mkForce false;};
          };
        };
        # }}}
      };
    };
}
