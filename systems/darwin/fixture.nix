{ config, ... }:
{
  system = "aarch64-darwin";
  modules = (builtins.attrValues config.rosetta.darwinModules) ++ [
    {
      users.users.remi = import ../../users/remi.nix;
      nix-homebrew.user = "remi";
    }
  ];
}
