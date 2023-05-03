{
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
  } @ inputs: let
    inherit (inputs.nixpkgs-stable.lib) attrValues;

    flakeModules = {
      config = ./config/flake-module.nix;
      configurations = ./configurations/flake-module.nix;
      packages = ./packages/flake-module.nix;
      lib = ./lib/flake-module.nix;
      home-manager = ./home-manager/flake-module.nix;
      darwin = ./darwin/flake-module.nix;
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({config, ...}: {
      debug = true;

      imports =
        [
          inputs.nix-pre-commit-hooks.flakeModule
        ]
        ++ attrValues flakeModules;

      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs-stable {
          inherit system;
          config = config.remi-nix.nixpkgsConfig;
          overlays = [emacs-overlay.overlays.default];
        };
      };

      flake = {
        inherit flakeModules;
      };
    });
}
