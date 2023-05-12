args: let
  mkCISystem = import ./ci.nix args;
in {
  ci_x86_64 = mkCISystem "x86_64-darwin";
  ci_aarch64 = mkCISystem "aarch64-darwin";
}
