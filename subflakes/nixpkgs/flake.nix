{
  outputs =
    {
      nixpkgs,
      nixpkgs-master,
      nixpkgs-firefox-darwin,
      fenix,
      zls,
      fonts,
      neovim,
      nixd,
      firefox-addons,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      eachSystem = lib.genAttrs lib.systems.flakeExposed;

      overlays = [
        fenix.overlays.default
        nixpkgs-firefox-darwin.overlay
        fonts.overlays.default
        (
          _: prev:
          let
            inherit (prev.stdenv) system;
          in
          {
            inherit (neovim.packages.${system}) neovim;
            inherit (nixd.packages.${system}) nixd;
            inherit (zls.packages.${system}) zls;
            inherit (nixpkgs-master.legacyPackages.${system}) atuin zig lix;

            firefox-addons = firefox-addons.packages.${system};
          }
        )
      ];

      nixpkgsConfig = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
        cudaSupport = true;
      };
    in
    {
      # Inherit from upstream
      inherit (nixpkgs) lib nixosModules htmlDocs;

      # But replace legacyPackages with the configured version
      legacyPackages = eachSystem (
        system:
        import nixpkgs {
          inherit system overlays;
          config = nixpkgsConfig;
        }
      );

      inherit overlays nixpkgsConfig;
    };

  inputs = {
    flake-compat.url = "github:nix-community/flake-compat";
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    zls.url = "github:zigtools/zls/0.13.0";
    fenix.url = "github:nix-community/fenix";
    fonts.url = "git+ssh://git@github.com/remi-gelinas/fonts";
    nixd.url = "github:nix-community/nixd/2.2.3";
    neovim.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs-unfree.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs-unfree";
    firefox-addons.url = "gitlab:rycee/nur-expressions/master?dir=pkgs/firefox-addons";
  };
}
