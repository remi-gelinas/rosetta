{mkEmacsPackage, ...}:
mkEmacsPackage "general-config" {
  code =
    #emacs-lisp
    ''
      (prefer-coding-system 'utf-8)

      ;;; Prefer newer '.el' files if the related '.elc' is older.
      (setopt load-prefer-newer t)

      ;;; Scrolling settings
      (setopt pixel-scroll-precision-mode t
        auto-window-vscroll nil
        fast-but-imprecise-scrolling t)

      ;;; Client bootstrapping
      (setopt initial-scratch-message ""
              inhibit-startup-screen nil)

      (setopt blink-cursor-mode nil)
      (defalias 'yes-or-no-p 'y-or-n-p)
      (setopt indent-tabs-mode nil)
      (setopt show-trailing-whitespace t)
      (setopt visible-bell t)
      (setopt pixel-scroll-precision-mode t)
    '';
}
