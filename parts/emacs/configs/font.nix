localFlake: {
  perSystem = {system, ...}: let
    name = "font-config";

    variableFont = "SF Pro";
    fixedFont = "PragmataPro Mono Liga";
  in {
    config.emacs.configPackages.${name} = {
      inherit name;
      requiresPackages = let
        configPackages = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
      in
        epkgs: [
          configPackages.rosetta-utils.finalPackage
          epkgs.use-package
        ];

      code =
        #src: emacs-lisp
        ''
          (eval-when-compile
            (require 'use-package))

          (use-package rosetta-utils
            :config
            (rosetta/hook-if-daemon
              "general-font-setup"
              (custom-theme-set-faces
                'user
                '(variable-pitch ((t (:family "${variableFont}" :height 200 :weight regular))))
                '(fixed-pitch ((t (:family "${fixedFont}" :height 180)))))))
        '';
    };
  };
}
