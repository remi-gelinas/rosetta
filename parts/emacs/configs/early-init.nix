{mkEmacsPackage, ...}:
mkEmacsPackage "early-init" {
  code =
    #src: emacs-lisp
    ''
      (setq package-enable-at-startup nil)
      (setq inhibit-splash-screen t)
    '';
}
