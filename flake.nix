{
  description = "Remi's personal Nix flake.";

  inputs = {
    # Package sets
    nixpkgs-master.url = github:NixOS/nixpkgs/master;
    nixpkgs-stable.url = github:NixOS/nixpkgs/nixpkgs-21.11-darwin;
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    nixos-stable.url = github:NixOS/nixpkgs/nixos-21.11;

    # NUR
    nur.url = github:nix-community/NUR;

    # Environment/system management
    darwin.url = github:LnL7/nix-darwin;
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Other sources
    flake-compat = { url = github:edolstra/flake-compat; flake = false; };
    flake-utils.url = github:numtide/flake-utils;

    # Nix community overlay for Emacs
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nur, darwin, home-manager, flake-utils, emacs-overlay, ... }@inputs:
    let
      # Some building blocks ------------------------------------------------------------------- {{{

      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton genAttrs;

      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = { allowUnfree = true; };
        overlays = attrValues self.overlays ++ singleton (
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86)
              starship; # TODO: remove when https://github.com/NixOS/nixpkgs/issues/160876 is fixed.
          })
        );
      };

      homeManagerStateVersion = "22.05";

      primaryUserInfo = {
        username = "rgelinas";
        fullName = "Remi Gelinas";
        email = "mail@remigelin.as";
        nixConfigDirectory = "/Users/rgelinas/.config/nixpkgs";
      };

      # Modules shared by most `nix-darwin` personal configurations.
      nixDarwinCommonModules = attrValues self.darwinModules ++ [
        # `home-manager` module
        home-manager.darwinModules.home-manager
        (
          { config, lib, pkgs, ... }:
          let
            inherit (config.users) primaryUser;
          in
          {
            nixpkgs = nixpkgsConfig;

            # Hack to support legacy worklows that use `<nixpkgs>` etc.
            nix.nixPath = { nixpkgs = "${primaryUser.nixConfigDirectory}/nixpkgs.nix"; };

            # `home-manager` config
            users.users.${primaryUser.username}.home = "/Users/${primaryUser.username}";

            home-manager = {
              useGlobalPkgs = true;

              extraSpecialArgs = {
                inherit inputs;
                inherit self;

                # Export NUR with no packages, to avoid infinite recursion issues
                nurNoPkgs = import nur {
                  nurpkgs = pkgs;
                  pkgs = throw "nixpkgs eval";
                };
              };

              users.${primaryUser.username} = {
                imports = attrValues self.homeManagerModules;
                home.stateVersion = homeManagerStateVersion;
                home.user-info = config.users.primaryUser;
              };
            };

            nix.registry.my.flake = self;
          }
        )
      ];

    in
    {
      # System outputs ------------------------------------------------------------------------- {{{

      darwinConfigurations = rec {
        # Mininal configurations to bootstrap systems
        bootstrap-x86 = makeOverridable darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
        };

        bootstrap-arm = bootstrap-x86.override { system = "aarch64-darwin"; };

        # My Apple Silicon macOS laptop config
        MacBookProAppleSilicon = darwinSystem {
          system = "aarch64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              users.primaryUser = primaryUserInfo;
            }
          ];
        };

        # My laptop config, compiled for Intel-based MacBooks
        MacBookProIntel = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              users.primaryUser = primaryUserInfo;
            }
          ];
        };
      };

      # Non-system outputs --------------------------------------------------------------------- {{{

      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        pkgs-master = final: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };

          # TODO: remove when https://github.com/NixOS/nixpkgs/pull/166661 hits `nixpkgs-unstable`.
          inherit (final.pkgs-master) kitty;
        };

        pkgs-stable = final: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

        pkgs-unstable = final: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

        # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        };

        # Community overlay and custom emacs derivation
        emacs-overlay = emacs-overlay.overlays.default;
        custom-emacs = import ./overlays/emacs.nix;

        # Personal Nix utils
        utils = import ./overlays/utils.nix;

        # Add personally used fonts
        fonts = import ./overlays/fonts.nix;

        # Make 'lib.sshKeys' available for reference elsewhere in configs
        ssh-keys = import ./overlays/ssh-keys.nix;

        # Make 'lib.colors' available for reference elsewhere
        colors = import ./overlays/colors.nix;

        # Other misc custom packages
        pkgs = import ./overlays/packages.nix;
      };

      darwinModules = {
        remi-bootstrap = import ./darwin/bootstrap.nix;
        remi-defaults = import ./darwin/defaults.nix;
        remi-general = import ./darwin/general.nix;
        remi-homebrew = import ./darwin/homebrew.nix;

        users-primaryUser = import ./modules/darwin/users.nix;
      };

      homeManagerModules = {
        remi-packages = import ./home/packages.nix;
        remi-git = import ./home/git.nix;
        remi-kitty = import ./home/kitty.nix;
        remi-fish = import ./home/fish.nix;
        remi-starship = import ./home/starship.nix;
        remi-gh = import ./home/gh.nix;
        remi-emacs = import ./home/emacs;

        remi-dotfiles = import ./home/dotfiles.nix;

        home-user-info = { lib, ... }: {
          options.home.user-info =
            (self.darwinModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
      };

      # Add re-export `nixpkgs` packages with overlays.
      # This is handy in combination with `nix registry add my /Users/rgelinas/.config/nixpkgs`
    } // flake-utils.lib.eachDefaultSystem (system: rec {
      legacyPackages = import inputs.nixpkgs-unstable {
        inherit system;
        inherit (nixpkgsConfig) config;
        overlays = with self.overlays; [
          pkgs-master
          pkgs-stable
          apple-silicon
        ];
      };

      # Use re-exported `nixpkgs` for flake dev shells
      devShell = import ./shell.nix { pkgs = legacyPackages; };
    });
}
