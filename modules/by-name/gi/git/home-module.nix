{ config, ... }:
{
  programs = {
    git = {
      enable = true;

      userEmail = config.email;
      userName = config.fullName;

      extraConfig = {
        commit.gpgSign = true;
        tag.gpgSign = true;
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAmy0+X2k/t2PzeMAN537Tz+JNDLI3ozJpQSc9hnjb4n";
        gpg.format = "ssh";
      };
    };
  };
}
