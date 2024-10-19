{
  lib,
  withSystem,
  inputs,
  ...
}:
let
  inherit (inputs) self nix-darwin;

  system = "aarch64-darwin";

  sharedDarwinModules = (import ../../modules/top-level/all-modules.nix { inherit lib; }).darwin;
in
{
  flake.darwinConfigurations.fixture = nix-darwin.lib.darwinSystem {
    inherit system;

    pkgs = withSystem system ({ pkgs, ... }: pkgs);

    modules = (builtins.attrValues sharedDarwinModules) ++ [
      inputs.nix-homebrew.darwinModules.nix-homebrew
      {
        system.configurationRevision = lib.mkDefault (self.shortRev or self.dirtyShortRev);
        nix-homebrew.user = "remi";
      }
    ];
  };
}
