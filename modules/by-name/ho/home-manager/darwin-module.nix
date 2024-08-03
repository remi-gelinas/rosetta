{ local }:
{ config, lib, ... }:
let
  inherit (local.config.rosetta) homeManagerModules;
in
{
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    sharedModules = lib.attrValues homeManagerModules;

    # Define a home-manager user for each nix-darwin user
    users =
      with lib;
      pipe config.users.users [
        # Filter out any nixbuild users
        (filterAttrs (username: _: !(hasPrefix "_" username)))
        (mapAttrs (
          username: user: {
            inherit (user) fullName username email;

            home.stateVersion = "24.05";
          }
        ))
      ];
  };
}
