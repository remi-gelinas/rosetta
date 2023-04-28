{
  config,
  lib,
  pkgs,
  ...
}: let
  mff = lib.fetchFromGitHub {
    owner = "mut-ex";
    repo = "minimal-functional-firefox";
    rev = "495d16b1e052e47f0c8adc073a9dda7ed32501ff";
    sha256 = lib.fakeSha256;
  };
in {
  programs.firefox = {
    enable = true;

    profiles = {
      default = {
        isDefault = true;

        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };
  };
}
