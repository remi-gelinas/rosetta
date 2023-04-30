{pkgs, ...}: {
  home.sessionVariables = {
    EDITOR = "${pkgs.custom.emacs}/bin/emacs -nw";
  };
}
