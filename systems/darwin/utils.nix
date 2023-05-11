{
  inputs,
  config,
  ...
}: {
  mkSystem = {
    system,
    primaryUser,
    extraPrimaryUserInfo ? {},
    modules ? [],
    extraModules ? [],
    homeModules ? [],
    extraHomeModules ? [],
    pkgs,
  }: let
    nur = import inputs.nur {
      nurpkgs = pkgs;
      pkgs = throw "nixpkgs eval";
    };
  in {
    inherit system;

    primaryUser =
      primaryUser // extraPrimaryUserInfo;

    homeModules =
      [
        nur.repos.rycee.hmModules.emacs-init
        {
          inherit (config.remi-nix) nixpkgsConfig;
        }
      ]
      ++ homeModules
      ++ extraHomeModules;

    modules =
      [
        {nixpkgs.overlays = [inputs.nixpkgs-firefox-darwin.overlay];}
        {
          inherit (config.remi-nix) nixpkgsConfig;
        }
      ]
      ++ modules
      ++ extraModules;
  };
}
