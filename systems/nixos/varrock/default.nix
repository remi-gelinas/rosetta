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
    ]
    ++ builtins.attrValues config.nixosModules;
}
