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
            rosetta = {
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

    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    nixpkgs-unfree.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nixd.url = "github:nix-community/nixd/2.2.2";
    neovim.url = "github:nix-community/neovim-nightly-overlay";
    lix.url = "git+https://git.lix.systems/lix-project/lix?ref=main";
    lix-module.url = "git+https://git.lix.systems/lix-project/nixos-module?ref=main";
    lix-module.inputs.lix.follows = "lix";
    firefox-addons.url = "gitlab:rycee/nur-expressions/master?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs-unfree";
    fenix.url = "github:nix-community/fenix";

    #--------------------------------------------------------
    # Homebrew dependencies for Darwin
    #--------------------------------------------------------

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };
}
