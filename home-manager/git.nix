{
  config,
  lib,
  pkgs,
  ...
}: {
  programs = {
    git = {
      enable = true;
      userEmail = config.home.user-info.email;
      userName = config.home.user-info.fullName;
      signing = {
        signByDefault = true;
        key = config.primary-user.gpgKey.subkeys.signing;
      };
    };
  };
}
