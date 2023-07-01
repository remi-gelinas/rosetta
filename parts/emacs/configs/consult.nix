{mkEmacsPackage, ...}:
mkEmacsPackage "consult-config" {
  requiresPackages = epkgs: [
    epkgs.consult
  ];

  requiresBinariesFrom = pkgs: [
    pkgs.fd
  ];

  code =
    #emacs-lisp
    ''
      (use-package consult
       :config
       ;; Use projectile for project roots
       (autoload 'projectile-project-root "projectile")
       (setq consult-project-function (lambda (_) (projectile-project-root))))
    '';
}
