localFlake: {
  perSystem = {system, ...}: let
    name = "frame-config";
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

          (use-package
           rosetta-utils
           :config
           (rosetta/hook-if-daemon
            "window-setup"
            (menu-bar-mode -1)
            (tool-bar-mode -1)
            (scroll-bar-mode -1)
            (add-to-list 'default-frame-alist '(fullscreen . maximized))
            (add-to-list 'default-frame-alist '(undecorated . t))
            (setq frame-inhibit-implied-resize t)))
        '';
    };
  };
}
