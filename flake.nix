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

    #========================================================
    # System configuration
    #========================================================

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin";

    #========================================================
    # Dependencies
    #========================================================

    disko.url = "github:nix-community/disko";
    fenix.url = "github:nix-community/fenix";
    fonts.url = "git+ssh://git@github.com/remi-gelinas/fonts";
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";
    lix-module.url = "git+https://git.lix.systems/lix-project/nixos-module?ref=refs/tags/2.92.0";
    nixd.url = "github:nix-community/nixd/2.6.2";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    stylix.url = "github:danth/stylix";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixvim.url = "github:nix-community/nixvim";
  };
}
