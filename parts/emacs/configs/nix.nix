{
  localFlake,
  mkEmacsPackage,
  ...
}:
mkEmacsPackage "nix-config" ({system, ...}: {
  requiresBinariesFrom = [
    (localFlake.withSystem system ({inputs', ...}: inputs'.nixd.packages.nixd))
  ];

  requiresPackages = epkgs: [
    epkgs.nix-mode
    epkgs.polymode
  ];

  code =
    #emacs-lisp
    ''
      (use-package nix-mode
      :config
        (unless (version< emacs-version "29.0")
          (use-package
          eglot
          :after nix-mode
          :config
          (add-to-list 'eglot-server-programs '(nix-mode . ("nixd")))
          :hook (nix-mode . eglot-ensure))))

      (use-package
       polymode
       :after nix-mode lua-mode
       :mode ((rx ".nix" eos) . poly-nix-emacs-lisp-mode)
       :config
       (unless (version< emacs-version "29.0")
        (use-package
         eglot
         :config
         (add-to-list 'polymode-run-these-after-change-functions-in-other-buffers 'eglot--after-change)
         (add-to-list 'polymode-run-these-before-change-functions-in-other-buffers 'eglot--before-change)))

       (define-hostmode poly-nix-hostmode :mode 'nix-mode)

       (define-innermode
        poly-emacs-lisp-string-nix-innermode
        :mode 'emacs-lisp-mode
        :body-indent-offset 2
        :head-matcher  (rx "#emacs-lisp" (* (or blank "\n")) (char "'") (char "'"))
        :tail-matcher (rx (char "'") (char "'"))
        :head-mode 'host
        :tail-mode 'host)

       (define-innermode
        poly-lua-string-nix-innermode
        :mode 'lua-mode
        :head-matcher  (rx "#lua" (* (or blank "\n")) (char "'") (char "'"))
        :tail-matcher (rx (char "'") (char "'"))
        :head-mode 'host
        :tail-mode 'host)

       (define-polymode
        poly-nix-emacs-lisp-mode
        :hostmode 'poly-nix-hostmode
        :innermodes '(poly-emacs-lisp-string-nix-innermode poly-lua-string-nix-innermode)))
    '';
})
