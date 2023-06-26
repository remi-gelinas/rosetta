{mkEmacsPackage, ...}:
mkEmacsPackage "early-init" (_: {
  code =
    #src: emacs-lisp
    ''
      (setq inhibit-splash-screen t)
    '';
})
