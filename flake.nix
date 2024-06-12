{
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        flake-parts-lib,
        withSystem,
        config,
        ...
      }:
      let
        parts = import ./parts {
          inherit (flake-parts-lib) importApply;
          inherit withSystem config inputs;
        };
      in
      {
        debug = true;
        imports = builtins.attrValues parts;

        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        flake.flakeModules = builtins.removeAttrs parts [ "outputs" ];
      }
    );

  inputs = {
    #========================================================
    # Repository and flake utilities
    #========================================================

    flake-compat.url = "git+https://git.lix.systems/lix-project/flake-compat?ref=main";
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

    nvfetcher.url = "github:berberman/nvfetcher";
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    nixpkgs-unfree.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nixd.url = "github:nix-community/nixd";
    neovim.url = "github:nix-community/neovim-nightly-overlay";
    lix.url = "git+https://git.lix.systems/lix-project/lix?rev=ce82067566a18fcd77ef1fe2f2575921fcceb665";
    lix-module.url = "git+https://git.lix.systems/lix-project/nixos-module";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.inputs.lix.follows = "lix";
    firefox-addons.url = "gitlab:rycee/nur-expressions/master?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs-unfree";
    fenix.url = "github:nix-community/fenix";
  };
}
