{mkEmacsPackage, ...}:
mkEmacsPackage "general-config" (_: {
  code =
    #src: emacs-lisp
    ''
      (setq inhibit-splash-screen nil)
      (setq blink-cursor-mode nil)
      (defalias 'yes-or-no-p 'y-or-n-p)
      (setq-default indent-tabs-mode nil)
      (setq-default show-trailing-whitespace t)
      (prefer-coding-system 'utf-8)
      (setq visible-bell t)
    '';
})
