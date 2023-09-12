{
  pkgs,
  config,
  ...
}: {
  programs = {
    gpg = {
      enable = true;
      mutableKeys = false;
      mutableTrust = false;

      publicKeys = [
        {
          text = config.home.user-info.gpgKey.publicKey;
          trust = 5;
        }
      ];

      scdaemonSettings = {
        disable-ccid = true;
      };
    };
  };

  home.file.".gnupg/gpg-agent.conf".text = let
    pinentry =
      if pkgs.stdenv.isDarwin
      then "pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac"
      else "";
  in ''
    max-cache-ttl 18000
    default-cache-ttl 18000
    ${pinentry}
    enable-ssh-support
  '';
}
