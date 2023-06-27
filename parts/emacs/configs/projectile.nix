{mkEmacsPackage, ...}:
mkEmacsPackage "projectile-config" {
  requiresPackages = epkgs: [
    epkgs.projectile
  ];

  code =
    #src: emacs-lisp
    ''
      (use-package projectile
       :init
       (projectile-mode +1)
       :bind (:map projectile-mode-map
             ("s-p" . projectile-command-map)
             ("C-c p" . projectile-command-map)))
    '';
}
