{mkEmacsPackage, ...}:
mkEmacsPackage "early-init" {
  requiresUsePackage = false;

  code =
    #src: emacs-lisp
    ''
      (setq inhibit-splash-screen t)
    '';
}
