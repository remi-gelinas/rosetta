{
  localFlake,
  mkEmacsPackage,
  ...
}:
mkEmacsPackage "default" ({
  system,
  lib,
  packageName,
  ...
}: let
  allConfigPackages = let
    pkgs = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
  in
    builtins.removeAttrs
    pkgs
    [packageName "early-init"];

  # Package requires
  requiresPackages =
    lib.attrsets.mapAttrsToList
    (_: pkg: pkg.finalPackage)
    allConfigPackages;

  # requires = with lib;
  #   pipe allConfigPackages [
  #     (attrsets.mapAttrsToList
  #       (_: pkg: "(require '${pkg.name})"))
  #     (builtins.concatStringsSep "\n")
  #   ];

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
  inherit requiresPackages;

  code =
    #emacs-lisp
    ''
      ${requiredBinaryPaths}
      ${requires}
    '';
})
