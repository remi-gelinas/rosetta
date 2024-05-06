{ mkEmacsPackage, ... }:
mkEmacsPackage "macrostep-config" {
  requiresPackages = epkgs: [
    epkgs.melpaPackages.macrostep
  ];

  code =
    #emacs-lisp
    ''
      (use-package macrostep)
    '';
}
