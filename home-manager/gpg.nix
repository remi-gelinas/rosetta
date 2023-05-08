{osConfig, ...}: {
  programs = {
    gpg = {
      enable = true;
      mutableKeys = false;
      mutableTrust = false;

      publicKeys = [
        {
          text = osConfig.users.primaryUser.gpgKey.publicKey;
          trust = 5;
        }
      ];

      scdaemonSettings = {
        disable-ccid = true;
      };
    };
  };
}
