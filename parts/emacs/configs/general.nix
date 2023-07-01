{mkEmacsPackage, ...}:
mkEmacsPackage "general-config" {
  code =
    #emacs-lisp
    ''
      (setq native-comp-async-report-warnings-errors nil)
      (setq blink-cursor-mode nil)
      (defalias 'yes-or-no-p 'y-or-n-p)
      (setq-default indent-tabs-mode nil)
      (setq-default show-trailing-whitespace t)
      (prefer-coding-system 'utf-8)
      (setq visible-bell t)
      (pixel-scroll-precision-mode)
    '';
}
