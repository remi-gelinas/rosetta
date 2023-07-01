{mkEmacsPackage, ...}:
mkEmacsPackage "orderless-config" {
  requiresPackages = epkgs: [
    epkgs.orderless
  ];

  code =
    #emacs-lisp
    ''
      (use-package orderless
       :custom
       (completion-styles '(orderless basic))
       (completion-category-overrides '((file (styles basic partial-completion)))))
    '';
}
