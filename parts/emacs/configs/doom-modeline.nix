{ mkEmacsPackage, ... }:
mkEmacsPackage "doom-modeline-config" {
  requiresPackages = epkgs: [
    epkgs.doom-modeline
  ];

  code =
    #emacs-lisp
    ''
      (use-package doom-modeline
       :defer t
       :commands doom-modeline-mode
       :init
       (doom-modeline-mode 1))
    '';
}
