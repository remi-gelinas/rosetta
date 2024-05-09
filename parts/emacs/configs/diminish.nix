{ mkEmacsPackage, ... }:
mkEmacsPackage "diminish-config" {
  requiresPackages = epkgs: [ epkgs.diminish ];

  code =
    #emacs-lisp
    ''
      (use-package diminish)
    '';
}
