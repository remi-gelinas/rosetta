{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  brewEnabled = config.homebrew.enable;
in
{
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
    autoUpdate = true;
    cleanup = "zap";
    global.brewfile = true;
    global.noLock = true;

    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
      "nrlquaker/createzap"
      "koekeishiya/formulae"
      "FelixKratz/formulae"
      "wez/wezterm"
      "1password/tap"
    ];

    brews = [
      "yabai"
      "sketchybar"
    ];

    casks = [
      "font-hack-nerd-font"
      "docker"
      "parsec"
      "alfred"
      "anydesk"
      "discord"
      "betterdiscord-installer"
      "wez/wezterm/wezterm"
      "1password/tap/1password-cli"
    ];

    masApps = {
      Tailscale = 1475387142;
    };
  };
}
