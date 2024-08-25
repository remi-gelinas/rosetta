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
        # Create a nixpkgs instance with all the fixings 
        mkPackages =
          system:
          let
            inherit (inputs)
              lix-module
              nixpkgs
              nixpkgs-master
              nixpkgs-firefox-darwin
              fenix
              fonts
              nixd
              neovim
              zls
              firefox-addons
              ;
          in
          import nixpkgs {
            inherit system;

            config = {
              allowUnfree = true;
            };

            overlays = [
              fenix.overlays.default
              nixpkgs-firefox-darwin.overlay
              fonts.overlays.default
              (_: _: {
                inherit (neovim.packages.${system}) neovim;
                inherit (nixd.packages.${system}) nixd;
                inherit (zls.packages.${system}) zls;
                inherit (nixpkgs-master.legacyPackages.${system}) atuin zig lix;

                firefox-addons = firefox-addons.packages.${system};
              })
              lix-module.overlays.lixFromNixpkgs

              # Expose packages from this flake in the package set
              (
                _: _:
                (withSystem system (
                  { config, ... }:
                  {
                    # TODO: Find a better way of merging this without recursion problems
                    inherit (config.rosetta.packages) gh-poi aerospace;
                  }
                ))
              )
            ];
          };

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

        flakeModules.pkgs = {
          perSystem =
            { system, ... }:
            {
              _module.args.pkgs = mkPackages system;
            };
        };
      in
      {
        imports = builtins.attrValues parts ++ builtins.attrValues flakeModules;

        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        flake.flakeModules = flakeModules;
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
    home-manager.url = "github:nix-community/home-manager/release-24.05";

    #========================================================
    # Dependencies
    #========================================================

    fenix.url = "github:nix-community/fenix";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs-unfree";
    firefox-addons.url = "gitlab:rycee/nur-expressions/master?dir=pkgs/firefox-addons";
    fonts.url = "git+ssh://git@github.com/remi-gelinas/fonts";
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";
    lix-module.url = "git+https://git.lix.systems/lix-project/nixos-module?ref=refs/tags/2.91.0";
    neovim.url = "github:nix-community/neovim-nightly-overlay";
    nixd.url = "github:nix-community/nixd/2.2.3";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
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
