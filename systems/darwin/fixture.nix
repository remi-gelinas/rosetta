{
  config,
  withSystem,
  inputs,
  ...
}:
let
  inherit (inputs) nix-darwin;

  system = "aarch64-darwin";
in
{
  flake.darwinConfigurations.fixture = nix-darwin.lib.darwinSystem {
    inherit system;

    pkgs = withSystem system ({ pkgs, ... }: pkgs);

    modules = (builtins.attrValues config.flake.darwinModules) ++ [
      {
        users.users.remi = import ../../users/remi.nix;
        nix-homebrew.user = "remi";
      }
    ];
  };
}
