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
        wayland.windowManager.hyprland = {
          enable = true;
          package = null;

          extraConfig = ''
            exec-once=${pkgs.dunst}/bin/dunst
            bindr=SUPER, 1, exec, pkill ${pkgs.tofi}/bin/tofi || ${pkgs.tofi}/bin/tofi
          '';
        };

        home.packages = [
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
          portalPackage = hyprland.packages.${system}.xdg-desktop-portal-hyprland;
        };

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.systemPackages = with pkgs; [
          git
          kitty
          hyprland.packages.${system}.hyprland
        ];

        services.pipewire = {
          enable = true;
          audio.enable = true;
          wireplumber.enable = true;
        };
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
