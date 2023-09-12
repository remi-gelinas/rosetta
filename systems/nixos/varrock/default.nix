{config}: system: {
  inherit system;
  inherit (config) primaryUser;

  homeModules =
    [
      {
        inherit (config) nixpkgsConfig colors;
      }
    ]
    ++ builtins.attrValues config.homeManagerModules;

  modules =
    [
      {nixpkgs.hostPlatform = system;}
      ./hardware.nix
      ({lib, ...}: {
        networking = {
          useDHCP = lib.mkForce true;
          networkmanager.enable = true;
        };
      })
    ]
    ++ builtins.attrValues config.nixosModules;
}
