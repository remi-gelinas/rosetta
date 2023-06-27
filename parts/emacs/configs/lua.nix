{mkEmacsPackage, ...}:
mkEmacsPackage "lua-config" {
  requiresPackages = epkgs: [
    epkgs.lua-mode
  ];

  code =
    #src: emacs-lisp
    ''
      (use-package lua-mode)
    '';
}
