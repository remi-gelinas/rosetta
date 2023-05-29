{
  withSystem,
  nixpkgs-master,
}: {
  pkgs,
  config,
  ...
}: {
  programs.wezterm = let
    pkgs-master = import nixpkgs-master {
      inherit (pkgs) system;
      config = config.nixpkgsConfig;
    };

    wezterm-config-org = withSystem pkgs.system ({config, ...}:
      config.legacyPackages.builders.tangleOrgDocument {
        src = ./config.org;
        templateVars = {
          FONT = "PragmataPro Mono Liga";
        };
      });
  in {
    enable = true;

    # Pull from nixpkgs-master until https://github.com/NixOS/nixpkgs/pull/233136 is merged to unstable
    package = pkgs-master.wezterm;

    extraConfig = builtins.readFile "${wezterm-config-org}/config.lua";
  };
}
