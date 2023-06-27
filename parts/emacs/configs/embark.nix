{mkEmacsPackage, ...}:
mkEmacsPackage "embark-config" {
  requiresPackages = epkgs: [
    epkgs.embark
    epkgs.embark-consult
  ];

  code =
    #src: emacs-lisp
    ''
      (use-package embark
       :init
       (setq prefix-help-command #'embark-prefix-help-command))

      (use-package embark-consult
       :hook
       (embark-collect-mode . consult-preview-at-point-mode))
    '';
}
