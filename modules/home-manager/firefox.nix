{ pkgs, ... }:
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

      extensions = with pkgs.firefox-addons; [
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
