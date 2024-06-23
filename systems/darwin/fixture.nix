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

  primaryUser = config.rosetta.primaryUser // {
    username = "runner";
    name = "";
    email = "";
  };

  homeModules = common ++ builtins.attrValues config.rosetta.homeManagerModules;
  modules = common ++ builtins.attrValues config.rosetta.darwinModules;
}
