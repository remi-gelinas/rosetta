_: {
  perSystem = _: let
    name = "elisp-config";
  in {
    config.emacs.configPackages.${name} = {
      inherit name;

      requiresPackages = epkgs: [
        epkgs.use-package
        epkgs.elisp-autofmt
      ];

      requiresBinariesFrom = pkgs: [
        pkgs.python311
      ];

      code =
        #src: emacs-lisp
        ''
          (eval-when-compile
            (require 'use-package))

          (use-package elisp-autofmt)
        '';
    };
  };
}
