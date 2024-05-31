_:
{ config, lib, ... }:
let
  inherit (lib) mkIf;
  brewEnabled = config.homebrew.enable;
in
{
  _file = ./homebrew.nix;

  environment.shellInit = mkIf brewEnabled ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';

  # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
  # For some reason if the Fish completions are added at the end of `fish_complete_path` they don't
  # seem to work, but they do work if added at the start.
  programs.fish.interactiveShellInit = mkIf brewEnabled ''
    if test -d (brew --prefix)"/share/fish/completions"
      set -p fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
      set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
  '';

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

    taps = [
      "homebrew/services"
      "nrlquaker/createzap"
      "1password/tap"
    ];

    casks = [
      "1password"
      "visual-studio-code"
      "discord"
      "orbstack"
    ];

    masApps = {
      XCode = 497799835;
    };
  };
}
