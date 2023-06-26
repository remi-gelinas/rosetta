{mkEmacsPackage, ...}:
mkEmacsPackage "early-init" {
  code =
    #src: emacs-lisp
    ''
      (setq inhibit-splash-screen t)
    '';
}
