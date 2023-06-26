{
  localFlake,
  mkEmacsPackage,
  ...
}:
mkEmacsPackage "nord-theme-config" ({system, ...}: let
  configPackages = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
in {
  requiresPackages = epkgs: [
    configPackages.rosetta-utils.finalPackage
    epkgs.nord-theme
    epkgs.use-package
  ];

  code =
    #src: emacs-lisp
    ''
      (eval-when-compile
        (require 'use-package))

      (use-package ${configPackages.rosetta-utils.name})
      (use-package
        nord-theme
        :after rosetta-utils
        :config
        (rosetta/hook-if-daemon "apply-nord-theme" (load-theme 'nord t)))
    '';
})
