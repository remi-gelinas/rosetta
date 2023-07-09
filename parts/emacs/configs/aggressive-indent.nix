{mkEmacsPackage, ...}:
mkEmacsPackage "aggressive-indent-config" {
  requiresPackages = epkgs: [
    epkgs.aggressive-indent
  ];

  code =
    #emacs-lisp
    ''
      (use-package aggressive-indent
        :commands aggressive-indent-mode
        :hook
        (emacs-lisp-mode . aggressive-indent-mode)
        :init
        (setq aggressive-indent-sit-for-time 2))
    '';
}
