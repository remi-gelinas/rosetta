{inputs, ...}: {
  pkgs,
  config,
  ...
}: {
  programs.firefox = let
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit (pkgs) system;
      config = config.nixpkgsConfig;
    };
    nur = import inputs.nur {
      nurpkgs = pkgs-unstable;
      pkgs = pkgs-unstable;
    };
  in {
    enable = true;
    package = pkgs.firefox-devedition-bin;

    profiles.personal = {
      id = 0;
      name = "Personal";
      isDefault = true;

      search = {
        force = true;
        default = "DuckDuckGo";
      };

      extensions = with nur.repos.rycee.firefox-addons; [
        ublock-origin
        sponsorblock
        reddit-enhancement-suite
        darkreader
        onepassword-password-manager
        facebook-container
      ];
    };
  };
}
