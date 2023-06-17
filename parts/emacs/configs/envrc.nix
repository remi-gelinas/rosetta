_: {
  perSystem = _: let
    name = "envrc-config";
  in {
    config.emacs.configPackages.${name} = {
      inherit name;
      requiresBinariesFrom = pkgs: [
        pkgs.direnv
      ];

      requiresPackages = epkgs: [
        epkgs.use-package
        epkgs.envrc
      ];

      code =
        #src: emacs-lisp
        ''
          (eval-when-compile
            (require 'use-package))

          (use-package envrc
            :config
            (envrc-global-mode))
        '';
    };
  };
}
