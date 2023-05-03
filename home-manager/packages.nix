{
  pkgs,
  flakeConfig,
  flakePackages,
  ...
}: {
  programs = {
    gpg = {
      enable = true;
      mutableKeys = false;
      mutableTrust = false;

      publicKeys = [
        {
          text = flakeConfig.remi-nix.primaryUser.gpgKey.publicKey;
          trust = 5;
        }
      ];

      scdaemonSettings = {
        disable-ccid = true;
      };
    };

    bat = {enable = true;};

    direnv = {
      enable = true;
      nix-direnv = {enable = true;};
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
    nodePackages.node2nix
    jq
    git-crypt
    ripgrep
    fd
    thefuck
    git-filter-repo

    nil
    nixpkgs-fmt
    alejandra

    kubernetes-helm
    kubectl
    flakePackages.kubectl-argo-rollouts
    argocd
    cmctl
    kind

    go
    go-task
  ];
}
