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

  username = "remi";
in
{
  flake.homeManagerConfigurations.${username} = lib.genAttrs config.systems (
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
              inherit username;

              email = "mail@remigelin.as";
              fullName = "Remi Gelinas";

              home = {
                inherit username;

                homeDirectory = "/home/${config.username}";
                stateVersion = "24.05";
              };
            }
          )
        ];
    }
  );
}
