{withSystem}: {
  lib,
  pkgs,
  ...
}: {
  # Nix configuration
  nix = {
    package = withSystem pkgs.system ({inputs', ...}: inputs'.nix.packages.nix);

    settings = {
      trusted-users = [
        "@admin"
      ];

      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://remi-gelinas-nix.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "remi-gelinas-nix.cachix.org-1:nj3SWe8g0jlpzvzvgE6znxY21XaONHxJ1qZQQsHBBNA="
      ];

      # https://github.com/NixOS/nix/issues/7273
      # Broken in official Nix installer, but fixed in https://github.com/DeterminateSystems/nix-installer/issues/449?
      auto-optimise-store = false;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") ["x86_64-darwin" "aarch64-darwin"];

      sandbox = true;
    };

    gc = {
      automatic = true;
      interval = {
        Hour = 12;
        Minute = 0;
      };
    };

    configureBuildUsers = true;
  };

  system.checks.verifyNixPath = false;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Shell configuration
  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  # Make Fish the default shell
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.fish.babelfishPackage = pkgs.babelfish;

  # https://github.com/LnL7/nix-darwin/issues/122
  programs.fish.shellInit = lib.mkIf pkgs.stdenv.isDarwin ''
    fish_add_path --prepend --global "$HOME/.nix-profile/bin" /nix/var/nix/profiles/default/bin /run/current-system/sw/bin
  '';

  environment.variables.SHELL = "${pkgs.fish}/bin/fish";

  # Install and setup ZSH to work with nix(-darwin) as well
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
