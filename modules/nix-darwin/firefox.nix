{lib, ...}: let
  mkFirefoxPreferences = domain: {
    "${domain}" = {
      EnterprisePoliciesEnabled = true;
      DisableAppUpdate = true;
    };
  };
in {
  system.defaults.CustomSystemPreferences = lib.mkMerge [
    (mkFirefoxPreferences "org.mozilla.firefoxdeveloperedition")
    (mkFirefoxPreferences "org.mozilla.firefox")
  ];
}
