localFlake: {
  perSystem = {system, ...}: let
    name = "nord-theme-config";
  in {
    config.emacs.configPackages.${name} = {
      inherit name;
      requiresPackages = let
        configPackages = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
      in
        epkgs: [
          configPackages.rosetta-utils.finalPackage
          epkgs.nord-theme
          epkgs.use-package
        ];

      code =
        #src: emacs-lisp
        ''
          (eval-when-compile
            (require 'use-package))

          (use-package rosetta-utils)
          (use-package
           nord-theme
           :after rosetta-utils
           :config
           (rosetta/hook-if-daemon "apply-nord-theme" (load-theme 'nord t)))
        '';
    };
  };
}
