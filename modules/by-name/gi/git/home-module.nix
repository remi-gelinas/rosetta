{ config, pkgs, ... }:
{
  programs = {
    git = {
      enable = true;

      userEmail = config.email;
      userName = config.fullName;

      # Configure Git to sign commits with Sigstore
      # https://github.com/sigstore/gitsign
      extraConfig = {
        commit.gpgSign = true;
        tag.gpgSign = true;

        gpg = {
          format = "x509";
          x509.program = "${pkgs.gitsign}/bin/gitsign";
        };
      };
    };
  };
}
