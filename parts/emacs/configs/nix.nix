{
  localFlake,
  mkEmacsPackage,
  ...
}:
mkEmacsPackage "nix-config" ({system, ...}: let
  nixpkgs-master = import localFlake.inputs.nixpkgs-master {
    inherit system;

    config = localFlake.config.nixpkgsConfig;
    overlays = [localFlake.inputs.emacs-unstable.overlays.default];
  };

  tree-sitter-nix =
    nixpkgs-master.emacsPackages.manualPackages.treesit-grammars.with-grammars
    (grammars: [
      grammars.tree-sitter-nix
    ]);
in {
  requiresBinariesFrom = [
    (localFlake.withSystem system ({inputs', ...}: inputs'.nixd.packages.nixd))
  ];

  requiresPackages = epkgs: [
    epkgs.polymode
    tree-sitter-nix
    (epkgs.trivialBuild {
      pname = "nix-ts-mode";
      requiresPackages = [tree-sitter-nix];

      src = nixpkgs-master.fetchFromGitHub {
        owner = "remi-gelinas";
        repo = "nix-ts-mode";
        rev = "bb398ee9c152fa5e33c1d48367de77be792a24b5";
        hash = "sha256-Atf+4EyScKUV1yrhs8Y52fcUoOdsyIJ5YrgSw9K96QQ=";
      };
    })
    # TODO: Ensure config.legacyPackages.emacsPackages.nix-ts-mode builds with Emacs >29 instead of 28
    # (localFlake.withSystem system ({config, ...}: config.legacyPackages.emacsPackages.nix-ts-mode))
  ];

  code =
    #emacs-lisp
    ''
      (use-package nix-ts-mode
        :defer t
        :commands nix-ts-mode
        :config
        (unless (version< emacs-version "29.0")
          (use-package
            eglot
            :config
            (add-to-list 'eglot-server-programs '(nix-ts-mode . ("nixd")))
            :hook (nix-ts-mode . eglot-ensure))))

      (use-package
        polymode
        :defer t
        :mode ((rx ".nix" eos) . poly-nix-mode)
        :config
        (unless (version< emacs-version "29.0")
          (use-package
            eglot
            :config
            (add-to-list 'polymode-run-these-after-change-functions-in-other-buffers 'eglot--after-change)
            (add-to-list 'polymode-run-these-before-change-functions-in-other-buffers 'eglot--before-change)))

        (define-hostmode poly-nix-hostmode :mode 'nix-ts-mode)

        (define-innermode
          poly-emacs-lisp-string-nix-innermode
          :mode 'emacs-lisp-mode
          :head-matcher  (rx "#emacs-lisp" (* (or blank "\n")) (char "'") (char "'"))
          :tail-matcher (rx (char "'") (char "'"))
          :head-mode 'host
          :tail-mode 'host
          :body-indent-offset 2)

        (define-innermode
          poly-lua-string-nix-innermode
          :mode 'lua-mode
          :head-matcher  (rx "#lua"(* (or blank "\n")) (char "'") (char "'"))
          :tail-matcher (rx
                         (char "'")
                         (char "'"))
          :head-mode 'host
          :tail-mode 'host)

        (define-polymode
          poly-nix-mode
          :hostmode 'poly-nix-hostmode
          :innermodes '(poly-emacs-lisp-string-nix-innermode poly-lua-string-nix-innermode)))
    '';
})
