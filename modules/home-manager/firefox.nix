{ pkgs, config, ... }:
let
  inherit (config.rosetta.inputs) firefox-addons;
in
{
  programs.firefox = {
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

      extensions =
        let
          addons = firefox-addons.packages.${pkgs.system};
        in
        with addons;
        [
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
