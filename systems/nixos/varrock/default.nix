{
  config,
  hyprland,
}: system: {
  inherit system;
  inherit (config) primaryUser;

  homeModules =
    [
      hyprland.homeManagerModules.default
      {
        inherit (config) nixpkgsConfig colors;
        wayland.windowManager.hyprland.enable = true;
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

        programs.hyprland = {
          enable = true;
          package = hyprland.packages.${system}.hyprland;
        };

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
      })
    ]
    ++ builtins.attrValues config.nixosModules;
}
