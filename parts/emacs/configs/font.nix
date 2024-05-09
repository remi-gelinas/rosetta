{ localFlake, mkEmacsPackage, ... }:
mkEmacsPackage "font-config" (
  { system, ... }:
  let
    variableFont = "SF Pro";
    fixedFont = "PragmataPro Mono Liga";

    configPackages = localFlake.withSystem system ({ config, ... }: config.emacs.configPackages);
  in
  {
    requiresPackages = [ configPackages.rosetta-utils.finalPackage ];

    code =
      #emacs-lisp
      ''
        (use-package
          ${configPackages.rosetta-utils.name}
          :defer t
          :commands rosetta/hook-if-daemon
          :init
          (rosetta/hook-if-daemon
           "general-font-setup"
           (custom-set-faces
            '(variable-pitch ((t (:family "${variableFont}" :height 180 :weight regular))))
            '(fixed-pitch ((t (:family "${fixedFont}" :height 180)))))))
      '';
  }
)
