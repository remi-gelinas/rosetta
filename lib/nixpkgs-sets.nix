{
  inputs,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    lib,
    config,
    ...
  }: {
    lib =
      rec {
        pkgs-master = import inputs.nixpkgs-master {
          inherit system;
          config = config.nixpkgsConfig;
        };
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit system;
          config = config.nixpkgsConfig;
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = config.nixpkgsConfig;
        };
        nur-no-pkgs = import inputs.nur {
          nurpkgs = pkgs-stable;
        };
      }
      // (lib.optionalAttrs (system == "aarch64-darwin") {
        pkgs-x86 = import inputs.nixpkgs-stable {
          system = "x86_64-darwin";
          config = config.nixpkgsConfig;
        };
      });
  };
}
