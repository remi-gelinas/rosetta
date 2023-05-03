{
  inputs,
  self,
  config,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    lib =
      rec {
        pkgs-master = import inputs.nixpkgs-master {
          inherit system;
          config = config.remi-nix.nixpkgsConfig;
        };
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit system;
          config = config.remi-nix.nixpkgsConfig;
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = config.remi-nix.nixpkgsConfig;
        };
        nur-no-pkgs = import inputs.nur {
          nurpkgs = pkgs-stable;
          pkgs = throw "nixpkgs eval";
        };
      }
      // (lib.optionalAttrs (system == "aarch64-darwin") {
        pkgs-x86 = import inputs.nixpkgs-stable {
          system = "x86_64-darwin";
          config = config.remi-nix.nixpkgsConfig;
        };
      });
  };
}
