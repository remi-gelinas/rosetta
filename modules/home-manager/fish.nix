{withSystem}: {
  pkgs,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;

    plugins = with pkgs; [
      {
        name = "bass";
        inherit (fishPlugins.bass) src;
      }
    ];

    interactiveShellInit = ''
      set -g fish_greeting ""
      ${pkgs.thefuck}/bin/thefuck --alias | source
    '';

    shellAliases = {
      emacs = lib.mkIf pkgs.stdenv.isDarwin (
        withSystem pkgs.system (
          {config, ...}: "${config.packages.emacs}/Applications/Emacs.app/Contents/MacOS/Emacs"
        )
      );
    };
  };
}
