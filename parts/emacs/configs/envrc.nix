{mkEmacsPackage, ...}:
mkEmacsPackage "envrc-config" {
  requiresBinariesFrom = pkgs: [
    pkgs.direnv
  ];

  requiresPackages = epkgs: [
    epkgs.use-package
    epkgs.envrc
  ];

  code =
    #src: emacs-lisp
    ''
      (eval-when-compile
        (require 'use-package))

      (use-package envrc
        :config
        (envrc-global-mode))
    '';
}
