{mkEmacsPackage, ...}:
mkEmacsPackage "magit-config" {
  requiresPackages = epkgs: [
    epkgs.magit
  ];

  code =
    #src: emacs-lisp
    ''
      (use-package magit)
    '';
}
