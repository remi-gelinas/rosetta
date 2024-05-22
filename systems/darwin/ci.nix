{ lib, config, ... }:
let
  common = [
    {
      config.rosetta = {
        inherit (config.rosetta) nixpkgsConfig colours;
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

  modules = [
    { config.homebrew.enable = lib.mkForce false; }
  ] ++ common ++ builtins.attrValues config.rosetta.darwinModules;
}
