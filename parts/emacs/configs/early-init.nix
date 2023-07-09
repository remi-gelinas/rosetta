{mkEmacsPackage, ...}:
mkEmacsPackage "early-init" {
  code =
    #emacs-lisp
    ''
      (setq package-enable-at-startup nil)
      (setq inhibit-startup-buffer-menu t)
      (setq inhbit-startup-screen t)
      (setq inhibit-splash-screen t)
    '';
}
