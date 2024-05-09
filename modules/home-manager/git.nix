{ config, ... }:
{
  programs = {
    git = {
      enable = true;

      userEmail = config.home.user-info.email;
      userName = config.home.user-info.fullName;

      signing = {
        signByDefault = true;
        key = config.home.user-info.gpgKey.subkeys.signing;
      };
    };
  };
}
