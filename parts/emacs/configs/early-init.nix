{mkEmacsPackage, ...}:
mkEmacsPackage "early-init" {
  code =
    #emacs-lisp
    ''
      (setq package-enable-at-startup nil)
      (setq inhibit-splash-screen t)
    '';
}
