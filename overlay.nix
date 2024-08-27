final: prev:
let
  pins = import ./_pins;

  dependencies = import ./_dependencies/generated.nix {
    inherit (final)
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };
in
prev.lib.composeManyExtension [
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
] final prev
