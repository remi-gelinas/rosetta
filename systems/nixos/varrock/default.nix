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
      {
        networking = {
          useDHCP = true;
          networkmanager.enable = true;
        };
      }
    ]
    ++ builtins.attrValues config.nixosModules;
}
