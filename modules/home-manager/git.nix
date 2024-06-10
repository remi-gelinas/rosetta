{ config, ... }:
{
  programs = {
    git = {
      enable = true;

      userEmail = config.email;
      userName = config.name;

      signing = {
        signByDefault = true;
        key = config.gpg.subkeys.signing;
      };
    };
  };
}
