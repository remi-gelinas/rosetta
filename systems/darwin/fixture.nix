{
  config,
  withSystem,
  inputs,
  ...
}:
let
  inherit (inputs) nix-darwin;

  name = "fixture";
  system = "aarch64-darwin";

  cfg = config.flake.darwinConfigurations.fixture;
in
{
  flake.darwinConfigurations.${name} = nix-darwin.lib.darwinSystem {
    inherit system;

    pkgs = withSystem system ({ pkgs, ... }: pkgs);

    modules = (builtins.attrValues config.flake.darwinModules) ++ [
      {
        users.users.remi = import ../../users/remi.nix;
        nix-homebrew.user = "remi";
      }
    ];
  };

  flake.checks.${system}."darwin-system-${name}" = cfg.system;
}
