{mkEmacsPackage, ...}:
mkEmacsPackage "aggressive-indent-config" {
  requiresPackages = epkgs: [
    epkgs.aggressive-indent
  ];

  code =
    #emacs-lisp
    ''
      (use-package aggressive-indent
        :hook
      (emacs-lisp-mode . aggressive-indent-mode)
        :config
      (setq aggressive-indent-sit-for-time 2))
    '';
}
