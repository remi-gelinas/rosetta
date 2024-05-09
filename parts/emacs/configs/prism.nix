{ mkEmacsPackage, ... }:
mkEmacsPackage "prism-config" {
  requiresPackages = epkgs: [ epkgs.melpaPackages.prism ];

  code =
    #emacs-lisp
    ''
      (use-package prism
       :defer t
       :commands prism-mode prism-whitespace-mode)
    '';
}
