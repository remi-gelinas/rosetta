{mkEmacsPackage, ...}:
mkEmacsPackage "rust-config" {
  requiresBinariesFrom = pkgs: [
    pkgs.rust-analyzer
  ];

  requiresPackages = epkgs: [
    epkgs.melpaPackages.rustic
  ];

  code =
    #emacs-lisp
    ''
      (use-package
        rustic
        :defer t
        :after inheritenv
        :mode ((rx ".rs" eos) . rustic-mode)
        :init
        (setq rustic-lsp-client 'eglot))
    '';
}
