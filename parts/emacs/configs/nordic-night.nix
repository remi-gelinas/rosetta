{ localFlake
, mkEmacsPackage
, ...
}:
mkEmacsPackage "nordic-night-config" ({ system, ... }:
let
  configPackages = localFlake.withSystem system ({ config, ... }: config.emacs.configPackages);
in
{
  requiresPackages = epkgs: [
    configPackages.rosetta-utils.finalPackage
    epkgs.melpaPackages.nordic-night-theme
  ];

  code =
    #emacs-lisp
    ''
      (use-package
       ${configPackages.rosetta-utils.name}
       :defer t
       :commands rosetta/hook-if-daemon)

      (use-package
        nordic-night-theme
        :config
        (rosetta/hook-if-daemon "apply-nord-theme" (load-theme 'nordic-night t)))
    '';
})
