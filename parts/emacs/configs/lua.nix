_: {
  perSystem = _: let
    name = "lua-config";
  in {
    config.emacs.configPackages.${name} = {
      inherit name;

      requiresPackages = epkgs: [
        epkgs.use-package
        epkgs.lua-mode
      ];

      code =
        #src: emacs-lisp
        ''
          (eval-when-compile
            (require 'use-package))

          (use-package lua-mode)
        '';
    };
  };
}
