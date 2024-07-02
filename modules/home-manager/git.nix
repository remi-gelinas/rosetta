{ config, ... }:
{
  programs = {
    git = {
      enable = true;

      userEmail = config.email;
      userName = config.fullName;

      signing = {
        signByDefault = true;
        key = "ssh::${config.sshKey}";
      };

      extraConfig.gpg.format = "ssh";
    };
  };
}
