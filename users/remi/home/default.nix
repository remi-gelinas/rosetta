{
  lib,
  config,
  withSystem,
  inputs,
  ...
}:
let
  userHomeModules = (import ../modules/top-level/all-modules.nix { inherit lib; }).home;
  sharedHomeModules = (import ../../../modules/top-level/all-modules.nix { inherit lib; }).home;

  username = "remi";
in
{
  flake.homeManagerConfigurations = lib.genAttrs config.systems (system: {
    ${username} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem system ({ pkgs, ... }: pkgs);

      modules =
        (builtins.attrValues sharedHomeModules)
        ++ (builtins.attrValues userHomeModules)
        ++ [
          inputs.nixvim.homeManagerModules.default
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
    };
  });
}
