{mkEmacsPackage, ...}:
mkEmacsPackage "marginalia-config" {
  requiresPackages = epkgs: [
    epkgs.marginalia
  ];

  code =
    #emacs-lisp
    ''
      (use-package marginalia
       :config
       (marginalia-mode))
    '';
}
