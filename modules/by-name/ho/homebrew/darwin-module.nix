{ config, pkgs, ... }:
{
  environment.shellInit = ''
    eval "$(${
      if pkgs.stdenv.isAarch64 then
        config.nix-homebrew.defaultArm64Prefix
      else
        config.nix-homebrew.defaultIntelPrefix
    }/bin/brew shellenv)"
  '';

  # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
  # For some reason if the Fish completions are added at the end of `fish_complete_path` they don't
  # seem to work, but they do work if added at the start.
  programs.fish.interactiveShellInit = ''
    if test -d (brew --prefix)"/share/fish/completions"
      set -p fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
      set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
  '';

  # nix-darwin Homebrew module
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };

    global = {
      brewfile = true;
      autoUpdate = true;
    };

    casks = [
      "1password"
      "visual-studio-code"
      "discord"
      "orbstack"
      "vmware-fusion"
    ];

    masApps = {
      XCode = 497799835;
    };
  };

  # nix-homebrew config
  nix-homebrew = {
    enable = true;
    enableRosetta = pkgs.stdenv.hostPlatform.isAarch64;
  };
}
