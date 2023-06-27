{
  localFlake,
  mkEmacsPackage,
  ...
}:
mkEmacsPackage "font-config" ({system, ...}: let
  variableFont = "SF Pro";
  fixedFont = "PragmataPro Mono Liga";

  configPackages = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
in {
  requiresPackages = [
    configPackages.rosetta-utils.finalPackage
  ];

  code =
    #src: emacs-lisp
    ''
      (use-package ${configPackages.rosetta-utils.name}
        :config
        (rosetta/hook-if-daemon
          "general-font-setup"
          (custom-theme-set-faces
            'user
            '(variable-pitch ((t (:family "${variableFont}" :height 200 :weight regular))))
            '(fixed-pitch ((t (:family "${fixedFont}" :height 180)))))))
    '';
})
