{mkEmacsPackage, ...}:
mkEmacsPackage "magit-config" (_: {
  requiresPackages = epkgs: [
    epkgs.use-package
    epkgs.magit
  ];

  code =
    #src: emacs-lisp
    ''
      (eval-when-compile
        (require 'use-package))

      (use-package magit)
    '';
})
