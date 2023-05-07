{
  config,
  osConfig,
  ...
}: {
  programs = {
    git = {
      enable = true;
      userEmail = config.home.user-info.email;
      userName = config.home.user-info.fullName;
      signing = {
        signByDefault = true;
        key = osConfig.users.primaryUser.gpgKey.subkeys.signing;
      };
    };
  };
}
