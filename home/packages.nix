{ config, lib, pkgs, ... }:
{
  programs = {
    gpg = {
      enable = true;
      mutableKeys = false;
      mutableTrust = false;
      publicKeys = [
        {
          text = pkgs.lib.sshKeys.remi.pubkey;
          trust = 5;
        }
      ];
      scdaemonSettings = {
        disable-ccid = true;
      };
    };

    bat = { enable = true; };

    direnv = {
      enable = true;
      nix-direnv = { enable = true; };
      stdlib = ''
        use_flake() {
          watch_file flake.nix
          watch_file flake.lock
          eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
        }
      '';
    };
  };

  home.file.".gnupg/gpg-agent.conf".text = ''
    max-cache-ttl 18000
    default-cache-ttl 18000
    pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    enable-ssh-support
  '';


  home.packages = with pkgs; [
    coreutils
    nodejs
    nodePackages.typescript
    nodePackages.node2nix
    yarn
    yarn2nix
    jq
    fnlfmt
    git-crypt
    ripgrep
    fd
    glow
    zk
    zellij
    elixir
    postgresql

    # TODO: move into programs.gh after https://github.com/cli/cli/pull/5378 lands
    gh
  ];
}
