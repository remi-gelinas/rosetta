{ mkEmacsPackage, ... }:
mkEmacsPackage "envrc-config" {
  requiresBinariesFrom = pkgs: [ pkgs.direnv ];

  requiresPackages = epkgs: [
    epkgs.envrc
    epkgs.inheritenv
  ];

  code =
    #emacs-lisp
    ''
      (use-package inheritenv)

      (use-package envrc
       :defer t
       :diminish envrc-mode
       :commands envrc-global-mode
       :init
       (envrc-global-mode))
    '';
}
