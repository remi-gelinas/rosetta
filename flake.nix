{
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        flake-parts-lib,
        withSystem,
        config,
        options,
        lib,
        ...
      }:
      let
        importApply =
          module:
          flake-parts-lib.importApply module {
            local = {
              inherit
                withSystem
                config
                options
                inputs
                lib
                ;
            };
          };

        parts = import ./parts { inherit importApply lib; };
      in
      {
        debug = true;

        imports = builtins.attrValues parts;

        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];
      }
    );

  inputs = {
    #========================================================
    # Repository and flake utilities
    #========================================================

    github-actions.url = "github:nix-community/nix-github-actions";
    github-actions.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";

    #========================================================
    # System configuration
    #========================================================

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    #========================================================
    # Dependencies
    #========================================================

    nixpkgs.url = "git+file:./?dir=subflakes/nixpkgs";
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";
    lix-module.url = "git+https://git.lix.systems/lix-project/nixos-module?ref=refs/tags/2.91.0";
    stylix.url = "github:danth/stylix";

    #--------------------------------------------------------
    # Homebrew dependencies for Darwin
    #--------------------------------------------------------

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };
}
