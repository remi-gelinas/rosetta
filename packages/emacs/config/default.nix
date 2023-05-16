# Configuration strategy lifted from Rycee's HM module at https://git.sr.ht/~rycee/nur-expressions/tree/master/item/hm-modules/emacs-init.nix
{pkgs, ...}: rec {
  earlyInit = builtins.readFile ./early-init.el;
  init = builtins.readFile ./init.el;

  packages = let
    epkgs = pkgs.emacsPackages;

    configDependencies = with epkgs; [
      nord-theme
    ];
  in [
    (epkgs.trivialBuild {
      pname = "rosetta-early-init";
      src = pkgs.writeText "rosetta-early-init.el" earlyInit;
      packageRequires = configDependencies;
    })
    (epkgs.trivialBuild {
      pname = "rosetta-init";
      src = pkgs.writeText "rosetta-init.el" init;
      packageRequires = [epkgs.use-package];
      preBuild = ''
        emacs -Q --batch \
          --eval "(require 'package)" \
          --eval "(setq package-quickstart-file \"rosetta-package-quickstart.el\")" \
          --eval "(package-quickstart-refresh)"

        sed -i '/no-byte-compile: t/d' rosetta-package-quickstart.el
      '';
    })
  ];
}
