{
  localFlake,
  mkEmacsPackage,
  ...
}:
mkEmacsPackage "frame-config" ({system, ...}: let
  configPackages = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
in {
  requiresPackages = [
    configPackages.rosetta-utils.finalPackage
  ];

  code =
    #emacs-lisp
    ''
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
})
