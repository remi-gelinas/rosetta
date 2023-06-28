{mkEmacsPackage, ...}:
mkEmacsPackage "marginalia-config" {
  requiresPackages = epkgs: [
    epkgs.marginalia
  ];

  code =
    #src: emacs-lisp
    ''
      (use-package marginalia
       :config
       (marginalia-mode))
    '';
}
