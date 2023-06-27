{mkEmacsPackage, ...}:
mkEmacsPackage "envrc-config" {
  requiresBinariesFrom = pkgs: [
    pkgs.direnv
  ];

  requiresPackages = epkgs: [
    epkgs.envrc
  ];

  code =
    #src: emacs-lisp
    ''
      (use-package envrc
       :init
       (envrc-global-mode))
    '';
}
