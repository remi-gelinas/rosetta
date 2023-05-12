{inputs, ...}: {
  pkgs,
  config,
  ...
}: {
  programs.firefox = let
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit (pkgs) system;
      config = config.nixpkgsConfig;
    };
    nur = import inputs.nur {
      nurpkgs = pkgs-stable;
      pkgs = pkgs-stable;
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
      ];
    };
  };
}
