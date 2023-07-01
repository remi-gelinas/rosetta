{mkEmacsPackage, ...}:
mkEmacsPackage "vertico-config" {
  requiresPackages = epkgs: [
    epkgs.vertico
  ];

  code =
    #emacs-lisp
    ''
      (use-package vertico
       :config
       (vertico-mode))
    '';
}
