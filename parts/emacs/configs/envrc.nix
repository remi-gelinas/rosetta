{mkEmacsPackage, ...}:
mkEmacsPackage "envrc-config" {
  requiresBinariesFrom = pkgs: [
    pkgs.direnv
  ];

  requiresPackages = epkgs: [
    epkgs.envrc
  ];

  code =
    #emacs-lisp
    ''
      (use-package envrc
       :config
       (envrc-global-mode))
    '';
}
