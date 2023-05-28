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

  home.file = {
    ".emacs.d/early-init.el".text = withSystem pkgs.system ({config, ...}: config.emacs.earlyInit);
  };
}
