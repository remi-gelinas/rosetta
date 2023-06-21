localFlake: {
  perSystem = {system, ...}: let
    name = "nix-config";
  in {
    config.emacs.configPackages.${name} = {
      inherit name;

      requiresBinariesFrom = pkgs: [
        pkgs.nil
      ];

      requiresPackages = epkgs: [
        epkgs.use-package

        epkgs.nix-mode
        epkgs.polymode
      ];

      code =
        #emacs-lisp
        ''
          (eval-when-compile
            (require 'use-package))

          (use-package nix-mode)
          (unless (version< emacs-version "29.0")
            (use-package
             eglot
             :after nix-mode
             :config
             (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
             :hook (nix-mode . eglot-ensure)))

          (use-package
           polymode
           :after nix-mode
           :mode ((rx ".nix" eos) . poly-nix-emacs-lisp-mode)
           :config (define-hostmode poly-nix-hostmode :mode 'nix-mode)

           (define-innermode
            poly-emacs-lisp-string-nix-innermode
            :mode 'emacs-lisp-mode
            :body-indent-offset 2
            :head-matcher  (rx "#emacs-lisp" (* (or blank "\n")) (char "'") (char "'"))
            :tail-matcher (rx (char "'") (char "'"))
            :head-mode 'host
            :tail-mode 'host)

           (define-polymode
            poly-nix-emacs-lisp-mode
            :hostmode 'poly-nix-hostmode
            :innermodes '(poly-emacs-lisp-string-nix-innermode)))
        '';
    };
  };
}
