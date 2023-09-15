{
  config,
  hyprland,
  nixpkgs-unstable,
}: system: rec {
  inherit system;
  primaryUser = config.primaryUser // {username = "remi";};

  homeModules =
    [
      hyprland.homeManagerModules.default
      ({pkgs, ...}: {
        inherit (config) nixpkgsConfig colors;
        wayland.windowManager.hyprland.enable = true;

        packages = [
          nixpkgs-unstable.legacyPackages.${system}.asusctl
          pkgs.lutris
        ];
      })
    ]
    ++ builtins.attrValues config.homeManagerModules;

  modules =
    [
      {nixpkgs.hostPlatform = system;}
      ./hardware.nix
      ({
        lib,
        pkgs,
        ...
      }: {
        networking = {
          useDHCP = lib.mkForce true;
          networkmanager.enable = true;
        };

        programs.hyprland = {
          enable = true;
          package = hyprland.packages.${system}.hyprland;
        };

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.systemPackages = [pkgs.git pkgs.kitty];
      })
      {
        services.asusd = {
          enable = true;
          enableUserService = true;
        };
      }
    ]
    ++ builtins.attrValues config.nixosModules;
}
