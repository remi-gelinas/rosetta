{mkEmacsPackage, ...}:
mkEmacsPackage "consult-config" {
  requiresPackages = epkgs: [
    epkgs.consult
    epkgs.projectile
  ];

  requiresBinariesFrom = pkgs: [
    pkgs.fd
  ];

  code =
    #emacs-lisp
    ''
      (use-package consult
       :after projectile
       :config
       ;; Use projectile for project roots
       (autoload 'projectile-project-root "projectile")
       (setq consult-project-function (lambda (_) (projectile-project-root))))
    '';
}
