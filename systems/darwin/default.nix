{
  config,
  nixpkgs-unstable,
  nixpkgs-firefox-darwin,
}: let
  mkCISystem = import ./ci.nix {inherit config nixpkgs-unstable nixpkgs-firefox-darwin;};
in {
  ci_x86_64 = mkCISystem "x86_64-darwin";
  ci_aarch64 = mkCISystem "aarch64-darwin";
}
