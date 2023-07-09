{
  localFlake,
  mkEmacsPackage,
  ...
}:
mkEmacsPackage "org-mode-config" ({system, ...}: let
  configPackages = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
in {
  requiresPackages = epkgs: [
    configPackages.rosetta-utils.finalPackage
    epkgs.org
  ];

  code =
    #emacs-lisp
    ''
      (use-package
       ${configPackages.rosetta-utils.name}
       :defer t
       :commands rosetta/hook-if-daemon)

      (use-package
      org
      :defer t
      :after ${configPackages.rosetta-utils.name}
      :config
      ;; Enable variable pitch fonts in org-mode
      (add-hook 'org-mode-hook 'variable-pitch-mode)

      (rosetta/hook-if-daemon
        "org-mode-font-setup"
        (custom-theme-set-faces
        'user
        '(org-block ((t (:inherit fixed-pitch))))
        '(org-code ((t (:inherit (shadow fixed-pitch)))))
        '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
        '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
        '(org-meta-line
          ((t (:inherit (font-lock-comment-face fixed-pitch)))))
        '(org-property-value ((t (:inherit fixed-pitch))) t)
        '(org-special-keyword
          ((t (:inherit (font-lock-comment-face fixed-pitch)))))
        '(org-tag
          ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
        '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))))
    '';
})
