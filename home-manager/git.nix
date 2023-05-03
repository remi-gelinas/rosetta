{
  flakeConfig,
  config,
  ...
}: {
  programs = {
    git = {
      enable = true;
      userEmail = config.home.user-info.email;
      userName = config.home.user-info.fullName;
      signing = {
        signByDefault = true;
        key = flakeConfig.remi-nix.primaryUser.gpgKey.subkeys.signing;
      };
    };
  };
}
