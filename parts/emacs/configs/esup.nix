{ mkEmacsPackage, ... }:
mkEmacsPackage "esup-config" {
  requiresPackages = epkgs: [
    epkgs.melpaPackages.esup
  ];

  code =
    #emacs-lisp
    ''
      (use-package esup
       :defer t
       :commands esup)
    '';
}
