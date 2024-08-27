args:
let
  # Overlays
  overlays = [
    (
      final: prev:
      let
        nixpkgs-master = import dependencies.nixpkgs-master.src { inherit (prev) system; };
      in
      {
        inherit (nixpkgs-master)
          atuin
          lix
          nixd

          # Required for Ghostty
          zig_0_13
          ;

        ghostty = final.callPackage "${pins.ghostty}/nix/package.nix" { };
        firefox-addons = prev.callPackage "${dependencies.firefox-addons.src}/pkgs/firefox-addons" { };
      }
    )

    (import dependencies.neovim-nightly-overlay.src)
    (import "${dependencies.fenix.src}/overlay.nix")
    (import "${dependencies.lix-module.src}/overlay.nix" { lix = null; })
    (import "${dependencies.fenix.src}/overlay.nix")
    (import "${pins.fonts}/pkgs/top-level/by-name-overlay.nix" "${pins.fonts}/pkgs/by-name")
  ];

  # Nixpkgs Config
  config = {
    allowUnfree = true;
  };

  pins = import ./_pins;

  pkgs = import pins.nixpkgs { };

  dependencies = import ./_dependencies/generated.nix {
    inherit (pkgs)
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };

  passthru = import pins.nixpkgs (
    args
    // {
      config = (args.config or { }) // config;
      overlays = (args.overlays or [ ]) ++ overlays;
    }
  );
in
passthru
