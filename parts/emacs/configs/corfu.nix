{ mkEmacsPackage, ... }:
mkEmacsPackage "corfu-config" {
  requiresPackages = epkgs: [
    epkgs.corfu
  ];

  code =
    #emacs-lisp
    ''
      (use-package corfu
       :defer t
       :commands global-corfu-mode
       :init
       (global-corfu-mode))
    '';
}
