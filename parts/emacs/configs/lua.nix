{ mkEmacsPackage, ... }:
mkEmacsPackage "lua-config" {
  requiresPackages = epkgs: [
    epkgs.lua-mode
  ];

  code =
    #emacs-lisp
    ''
      (use-package lua-mode
       :defer t
       :commands lua-mode)
    '';
}
