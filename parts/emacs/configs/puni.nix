{mkEmacsPackage, ...}:
mkEmacsPackage "puni-config" {
  requiresPackages = epkgs: [
    epkgs.melpaPackages.puni
  ];

  code =
    #emacs-lisp
    ''
      (use-package puni
       :defer t
       :commands puni-global-mode
       :init
       (puni-global-mode))
    '';
}
