{withSystem}: {pkgs, ...}: let
  emacs = withSystem pkgs.system ({config, ...}: config.emacs.package);
in {
  home.sessionVariables = {
    EDITOR = "${emacs}/bin/emacsclient -c";
    VISUAL = "${emacs}/bin/emacsclient -c";
  };

  programs.emacs = {
    enable = true;
    package = emacs;
  };

  programs.fish.shellAliases = {
    emacs = pkgs.lib.mkIf pkgs.stdenv.isDarwin (
      withSystem pkgs.system (
        {config, ...}: "${config.emacs.package}/Applications/Emacs.app/Contents/MacOS/Emacs"
      )
    );
  };
}
