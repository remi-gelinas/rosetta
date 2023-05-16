{self, ...}: {pkgs, ...}: let
  inherit (self.packages.${pkgs.system}) emacs;
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
    ".emacs.d/early-init.el".text = ''
      (require 'rosetta-early-init)
    '';

    ".emacs.d/init.el".text = ''
      (require 'rosetta-init)
    '';
  };
}
