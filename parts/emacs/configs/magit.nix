{mkEmacsPackage, ...}:
mkEmacsPackage "magit-config" {
  requiresPackages = epkgs: [
    epkgs.magit
  ];

  code =
    #emacs-lisp
    ''
      (use-package magit)
    '';
}
