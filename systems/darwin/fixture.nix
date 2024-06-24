{ config, ... }:
let
  common = [
    {
      config.rosetta = {
        inherit (config.rosetta) colours;
      };
    }
  ];
in
{
  system = "aarch64-darwin";
  homeModules = common ++ builtins.attrValues config.rosetta.homeManagerModules;
  modules = common ++ builtins.attrValues config.rosetta.darwinModules;
}
