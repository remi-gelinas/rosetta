localFlake: {lib, ...}: let
  inherit (localFlake.inputs) nixpkgs-unstable nix-github-actions self;

  # Architecture to Github Runner label mappings
  platforms = {
    x86_64-linux = "ubuntu-latest";
    x86_64-darwin = "macos-latest";
  };
in {
  flake.githubActions = nix-github-actions.lib.mkGithubMatrix {
    inherit platforms;

    checks = {
      inherit (self.checks) x86_64-linux;

      x86_64-darwin = let
        pkgs = import nixpkgs-unstable {
          system = "x86_64-darwin";
        };
      in {
        # Aggregate all tests into one derivation so that only one GHA runner is scheduled for all darwin jobs
        aggregate = with pkgs.lib;
          pkgs.runCommand "x86_64-darwin-aggregate"
          {
            env.TEST_INPUTS = pipe self.checks.x86_64-darwin [
              (filterAttrs (_: v: isDerivation v))
              attrValues
              (concatStringsSep " ")
            ];
          } "touch $out";
      };

      # Enable once self-hosted M1 runners are configured.
      # aarch64-darwin = let
      #   pkgs = import nixpkgs-unstable {
      #     system = "aarch64-darwin";
      #   };
      # in {
      #   # Aggregate all tests into one derivation so that only one GHA runner is scheduled for all darwin jobs
      #   aggregate = with pkgs.lib;
      #     pkgs.runCommand "aarch64-darwin-aggregate"
      #     {
      #       env.TEST_INPUTS = pipe self.checks.aarch64-darwin [
      #         (filterAttrs (n: v: isDerivation v))
      #         attrValues
      #         (concatStringsSep " ")
      #       ];
      #     } "touch $out";
      # };
    };
  };
}
