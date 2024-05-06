{ mkEmacsPackage, ... }:
mkEmacsPackage "marginalia-config" {
  requiresPackages = epkgs: [
    epkgs.marginalia
  ];

  code =
    #emacs-lisp
    ''
      (use-package marginalia
       :commands marginalia-mode
       :init
       (marginalia-mode))
    '';
}
