{
  outputs =
    {
      flake-parts,
      nixpkgs,
      self,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      let
        parts = import ./parts;
      in
      {
        imports = [ (import "${flake-parts}/all-modules.nix") ] ++ builtins.attrValues parts;

        systems = [
          "aarch64-linux"
          "x86_64-linux"
          "aarch64-darwin"
        ];

        perSystem =
          { system, ... }:
          {
            _module.args.pkgs = import nixpkgs {
              inherit system;

              config.allowUnfree = true;
              overlays = [ self.overlays.default ];
            };
          };
      }
    );

  inputs = {
    #========================================================
    # Repository and flake utilities
    #========================================================

    flake-compat.url = "git+https://git.lix.systems/lix-project/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.url = "github:cachix/git-hooks.nix";
    github-actions.inputs.nixpkgs.follows = "nixpkgs";
    github-actions.url = "github:nix-community/nix-github-actions";

    #========================================================
    # System configuration
    #========================================================

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";

    #========================================================
    # Dependencies
    #========================================================

    fenix.url = "github:nix-community/fenix";
    fonts.url = "git+ssh://git@github.com/remi-gelinas/fonts";
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";
    lix-module.url = "git+https://git.lix.systems/lix-project/nixos-module?ref=refs/tags/2.91.0";
    neovim.url = "github:nix-community/neovim-nightly-overlay";
    nixd.url = "github:nix-community/nixd/2.2.3";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-unfree.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    stylix.url = "github:danth/stylix";
    zls.url = "github:zigtools/zls/0.13.0";

    #--------------------------------------------------------
    # Homebrew dependencies for Darwin
    #--------------------------------------------------------

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };
}
