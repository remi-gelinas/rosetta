topLevel: {config, osConfig, ...}: {
  programs = {
    git = {
      enable = true;
      userEmail = config.home.user-info.email;
      userName = config.home.user-info.fullName;
      signing = {
        signByDefault = true;
        # key = osConfig.remi-nix.primaryUser.gpgKey.subkeys.signing;
        key = topLevel.config.remi-nix.primaryUser.gpgKey.subkeys.signing;
      };
    };
  };
}
