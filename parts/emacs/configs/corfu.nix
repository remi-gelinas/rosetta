{mkEmacsPackage, ...}:
mkEmacsPackage "corfu-config" {
  requiresPackages = epkgs: [
    epkgs.corfu
  ];

  code =
    #emacs-lisp
    ''
      (use-package corfu
       :config
       (global-corfu-mode))
    '';
}
