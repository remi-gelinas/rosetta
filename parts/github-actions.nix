localFlake: { lib, ... }:
let
  inherit (localFlake.inputs) nixpkgs-unstable nix-github-actions self;

  # Architecture to Github Runner label mappings
  platforms = {
    x86_64-linux = "ubuntu-latest";
    aarch64-darwin = "macos-14-large";
  };
in
{
  flake.githubActions = nix-github-actions.lib.mkGithubMatrix {
    inherit platforms;

    checks = {
      inherit (self.checks) x86_64-linux;

      aarch64-darwin =
        let
          pkgs = import nixpkgs-unstable {
            system = "aarch64-darwin";
          };
        in
        {
          # Aggregate all tests into one derivation so that only one GHA runner is scheduled for all darwin jobs
          aggregate = with pkgs.lib;
            pkgs.runCommand "aarch64-darwin-aggregate"
              {
                env.TEST_INPUTS = pipe self.checks.aarch64-darwin [
                  (filterAttrs (_: v: isDerivation v))
                  attrValues
                  (concatStringsSep " ")
                ];
              } "touch $out";
        };
    };
  };
}
