{
  lib,
  config,
  withSystem,
  inputs,
  ...
}:
let
  userHomeModules = (import ../modules/top-level/all-modules.nix { inherit lib; }).home;
  sharedHomemodules = (import ../../../modules/top-level/all-modules.nix { inherit lib; }).home;
in
{
  flake.homeManagerConfigurations.remi = lib.genAttrs config.systems (
    system:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem system ({ pkgs, ... }: pkgs);

      modules =
        (builtins.attrValues sharedHomemodules)
        ++ (builtins.attrValues userHomeModules)
        ++ [
          (
            { config, ... }:
            {
              username = "remi";

              home = {
                username = "remi";
                homeDirectory = "/home/${config.username}";
                stateVersion = "24.05";
              };
            }
          )
        ];
    }
  );
}
