localFlake: {
  perSystem = {
    system,
    lib,
    ...
  }: let
    name = "default";
  in {
    config.emacs.configPackages.${name} = let
      allConfigPackages =
        builtins.removeAttrs
        (localFlake.withSystem system ({config, ...}: config.emacs.configPackages))
        [name];

      # Package requires
      requiresPackages = _:
        lib.attrsets.mapAttrsToList
        (_: pkg: pkg.finalPackage)
        allConfigPackages;

      requires = with lib;
        pipe allConfigPackages [
          (attrsets.mapAttrsToList
            (_: pkg: "(require '${pkg.name})"))
          (builtins.concatStringsSep "\n")
        ];

      # Make binaries required by packages available
      allRequiredBinaryPackages = with lib;
        pipe allConfigPackages [
          (attrsets.mapAttrsToList (_: pkg: pkg.finalBinaryPackages))
          builtins.concatLists
        ];

      requiredBinaryPaths = with lib;
        optionalString ((builtins.length allRequiredBinaryPackages) != 0) ''
          (dolist (dir '(${concatMapStringsSep " " (drv: ''"${drv}/bin"'') allRequiredBinaryPackages}))
            (add-to-list 'exec-path dir))
          (setenv "PATH" (concat "${strings.makeBinPath allRequiredBinaryPackages}:" (getenv "PATH")))
        '';
    in {
      inherit name requiresPackages;
      code =
        #src: emacs-lisp
        ''
          ${requiredBinaryPaths}
          ${requires}

          ;; Disable startup message.
          (setq inhibit-startup-screen t)

          ;; Don't blink the cursor.
          (setq blink-cursor-mode nil)

          ;; Accept 'y' and 'n' rather than 'yes' and 'no'.
          (defalias 'yes-or-no-p 'y-or-n-p)

          ;; Always show line and column number in the mode line.
          (line-number-mode)
          (column-number-mode)

          ;; Ensure spaces instead of tabs, 2 spaces per indentation
          (setq-default
          indent-tabs-mode nil
          tab-width 2
          c-basic-offset 2)

          ;; Remove trailing whitespace
          (setq-default show-trailing-whitespace t)

          ;; Prefer UTF-8
          (prefer-coding-system 'utf-8)

          ;; Disable bell
          (setq visible-bell t)
        '';
    };
  };
}
