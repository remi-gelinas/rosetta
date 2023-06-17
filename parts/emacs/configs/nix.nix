_: {
  perSystem = _: let
    name = "nix-config";
  in {
    config.emacs.configPackages.${name} = {
      inherit name;
      requiresBinariesFrom = pkgs: [
        pkgs.nil
      ];

      requiresPackages = epkgs: [
        epkgs.nix-mode
        epkgs.polymode
        epkgs.use-package
      ];

      code =
        #src: emacs-lisp
        ''
          (eval-when-compile
            (require 'use-package))

          (use-package nix-mode)
          (unless (version< emacs-version "29.0")
            (use-package eglot
              :after nix-mode
              :config (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
              :hook (nix-mode . eglot-ensure)))

          (use-package
            polymode
            :after nix-mode
            :mode ((rx ".nix" eos) . poly-nix-emacs-lisp-mode)
            :config
            (define-hostmode poly-nix-hostmode :mode 'nix-mode)

            (define-innermode poly-emacs-lisp-string-nix-innermode
              :mode 'emacs-lisp-mode
              :head-matcher  (rx "#src: emacs-lisp" (char "\n") (* blank) (= 2 (char "'")))
              :tail-matcher (rx (= 2 (char "'")))
              :head-mode 'host
              :tail-mode 'host)

            (define-polymode poly-nix-emacs-lisp-mode
              :hostmode 'poly-nix-hostmode
              :innermodes '(poly-emacs-lisp-string-nix-innermode)))


          ;; LSP config
        '';
    };
  };
}
