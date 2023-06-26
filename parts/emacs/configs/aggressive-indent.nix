{mkEmacsPackage, ...}:
mkEmacsPackage "aggressive-indent-mode-config" {
  requiresPackages = epkgs: [
    epkgs.use-package
    epkgs.aggressive-indent
  ];

  code =
    #emacs-lisp
    ''
      (eval-when-compile
        (require 'use-package))

      (use-package aggressive-indent
        :commands
        (aggressive-indent-mode)
        :hook
        (emacs-lisp-mode . aggressive-indent-mode)
        :config
        (setq aggressive-indent-sit-for-time 2)
        )
    '';
}
