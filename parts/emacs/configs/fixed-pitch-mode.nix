{
  localFlake,
  mkEmacsPackage,
  ...
}:
mkEmacsPackage "fixed-pitch-mode-config" ({
  system,
  pkgs,
  ...
}: let
  configPackages = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
in {
  requiresPackages = epkgs: [
    configPackages.rosetta-utils.finalPackage
    (epkgs.trivialBuild {
      pname = "fixed-pitch-mode";

      src = pkgs.fetchFromGitHub {
        owner = "cstby";
        repo = "fixed-pitch-mode";
        rev = "112610111ea33c24ca7807eb884ec1ac7785fba4";
        hash = "sha256-DSRHAVJRJnRZB0LM/Vl2XSE/84Sh83LschtCJqN4Z7M=";
      };
    })
  ];

  code =
    #emacs-lisp
    ''
      (use-package fixed-pitch
       :after ${configPackages.rosetta-utils.name})
    '';
})
