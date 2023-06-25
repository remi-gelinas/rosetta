localFlake: {
  perSystem = {
    system,
    lib,
    ...
  }: let
    name = "default";
  in {
    config.emacs.configPackages.${name} = let
      allConfigPackages = let
        pkgs = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
      in
        builtins.removeAttrs
        pkgs
        [name "early-init"];

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
        '';
    };
  };
}
