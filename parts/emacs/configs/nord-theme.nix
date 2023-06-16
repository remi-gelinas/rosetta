localFlake: {
  perSystem = {system, ...}: let
    name = "nord-theme-config";
  in {
    config.emacs.configPackages.${name} = {
      inherit name;
      requiresPackages = let
        configPackages = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
      in
        epkgs: [
          configPackages.rosetta-utils.finalPackage
          epkgs.nord-theme
        ];

      code = ''
        (require 'rosetta-utils)
        (require 'nord-theme)
        (rosetta/hook-if-daemon "apply-nord-theme" (load-theme 'nord t))
      '';
    };
  };
}
