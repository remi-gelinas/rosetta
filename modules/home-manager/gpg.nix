{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.gpg = {
    publicKey = mkOption { type = types.str; };
    subkeys = mkOption { type = types.attrsOf types.str; };
  };

  config = {
    programs = {
      gpg = {
        enable = true;

        mutableKeys = false;
        mutableTrust = false;

        publicKeys = [
          {
            text = config.gpg.publicKey;
            trust = 5;
          }
        ];

        scdaemonSettings = {
          disable-ccid = true;
        };
      };
    };

    home.file.".gnupg/gpg-agent.conf".text = ''
      max-cache-ttl 18000
      default-cache-ttl 18000
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
      enable-ssh-support
    '';
  };
}
