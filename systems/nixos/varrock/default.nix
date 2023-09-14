{
  config,
  hyprland,
  nixpkgs-unstable,
}: system: {
  inherit system;
  inherit (config) primaryUser;

  homeModules =
    [
      hyprland.homeManagerModules.default
      {
        inherit (config) nixpkgsConfig colors;
        wayland.windowManager.hyprland.enable = true;

        packages = [
          nixpkgs-unstable.legacyPackages.${system}.asusctl
        ];
      }
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
        environment.systemPackages = [pkgs.git];
      })
      {
        services.asusd = {
          enable = true;
          enableUserService = true;

          auraConfig = ''
          '';
        };
      }
    ]
    ++ builtins.attrValues config.nixosModules;
}
