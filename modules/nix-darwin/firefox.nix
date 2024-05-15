_:
{ lib, ... }:
let
  mkFirefoxPreferences = domain: {
    "${domain}" = {
      EnterprisePoliciesEnabled = true;
      DisableAppUpdate = true;
    };
  };
in
{
  _file = ./firefox.nix;

  system.defaults.CustomSystemPreferences = lib.mkMerge [
    (mkFirefoxPreferences "org.mozilla.firefoxdeveloperedition")
    (mkFirefoxPreferences "org.mozilla.firefox")
  ];
}
