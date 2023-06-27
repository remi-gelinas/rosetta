{mkEmacsPackage, ...}:
mkEmacsPackage "vertico-config" {
  requiresPackages = epkgs: [
    epkgs.vertico
  ];

  code =
    #src: emacs-lisp
    ''
      (use-package vertico
       :init
       (vertico-mode))
    '';
}
