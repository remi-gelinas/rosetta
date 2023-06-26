{mkEmacsPackage, ...}:
mkEmacsPackage "lua-config" {
  requiresPackages = epkgs: [
    epkgs.use-package
    epkgs.lua-mode
  ];

  code =
    #src: emacs-lisp
    ''
      (eval-when-compile
        (require 'use-package))

      (use-package lua-mode)
    '';
}
