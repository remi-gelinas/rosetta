{ lib, config, ... }:
let
  inherit (lib) mapAttrsToList foldAttrs recursiveUpdate;

  cfg = config.flake.nixosConfigurations;
in
{
  imports = [ ../systems/nixos ];

  config.flake.checks = lib.pipe cfg [
    (mapAttrsToList (
      name: system: {
        ${system.pkgs.system} = {
          "nixos-system-${name}" = system.config.system.build.toplevel;
        };
      }
    ))
    (foldAttrs recursiveUpdate { })
  ];
}
