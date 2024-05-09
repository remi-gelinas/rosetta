{ mkEmacsPackage, ... }:
mkEmacsPackage "gcmh-config" {
  requiresPackages = epkgs: [ epkgs.gcmh ];

  code =
    #emacs-lisp
    ''
      (use-package gcmh
       :defer t
       :commands gcmh-mode
       :diminish gcmh-mode
       :init
       (gcmh-mode 1))
    '';
}
