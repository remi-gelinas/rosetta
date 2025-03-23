{
  programs = {
    git = {
      enable = true;

      userEmail = "mail@remigelin.as";
      userName = "Remi Gelinas";

      signing = {
        signByDefault = true;
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAmy0+X2k/t2PzeMAN537Tz+JNDLI3ozJpQSc9hnjb4n";
      };

      extraConfig.gpg.format = "ssh";
    };
  };
}
