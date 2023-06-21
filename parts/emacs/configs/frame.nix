localFlake: {
  perSystem = {system, ...}: let
    name = "frame-config";

    configPackages = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
  in {
    config.emacs.configPackages.${name} = {
      inherit name;

      requiresPackages = epkgs: [
        configPackages.rosetta-utils.finalPackage
        epkgs.use-package
      ];

      code =
        #src: emacs-lisp
        ''
          (eval-when-compile
            (require 'use-package))

          (use-package
           ${configPackages.rosetta-utils.name}
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
