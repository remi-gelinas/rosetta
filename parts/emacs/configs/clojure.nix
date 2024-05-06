{ mkEmacsPackage, ... }:
mkEmacsPackage "clojure-config" {
  requiresBinariesFrom = pkgs: [
    pkgs.clojure
    pkgs.clojure-lsp
  ];

  requiresPackages = epkgs: [
    epkgs.melpaPackages.cider
  ];

  code =
    #emacs-lisp
    ''
      (use-package
        cider
        :defer t
        :config
        (unless (version< emacs-version "29.0")
          (use-package
            eglot
            :config
            (add-to-list 'eglot-server-programs '(clojure-mode . ("clojure-lsp")))
            :hook (clojure-mode . eglot-ensure))))
    '';
}
