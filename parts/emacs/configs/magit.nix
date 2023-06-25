_: {
  perSystem = _: let
    name = "magit-config";
  in {
    config.emacs.configPackages.${name} = {
      inherit name;

      requiresPackages = epkgs: [
        epkgs.use-package
        epkgs.magit
      ];

      code =
        #src: emacs-lisp
        ''
          (eval-when-compile
            (require 'use-package))

          (use-package magit)
        '';
    };
  };
}
