{mkEmacsPackage, ...}:
mkEmacsPackage "corfu-config" {
  requiresPackages = epkgs: [
    epkgs.corfu
  ];

  code =
    #src: emacs-lisp
    ''
      (use-package corfu
       :init
       (global-corfu-mode))
    '';
}
