# Configuration strategy inspired by Rycee's HM module at https://git.sr.ht/~rycee/nur-expressions/tree/master/item/hm-modules/emacs-init.nix
{pkgs, ...}: rec {
  rosetta-config = with pkgs.emacsPackages;
    trivialBuild {
      pname = "rosetta-config";

      src = ./src;
      buildInputs = [org];

      buildPhase = ''
        emacs -Q --batch \
          --eval "(require 'org)" \
          --eval "(org-babel-tangle-file \"config.org\")"
      '';

      installPhase = ''
        install -d $out
        install *.el $out
      '';
    };

  packages = let
    epkgs = pkgs.emacsPackages;

    configDependencies = with epkgs; [
      nord-theme
      elisp-autofmt
    ];
  in [
    (epkgs.trivialBuild {
      pname = "rosetta-early-init";
      packageRequires = configDependencies;
      src = pkgs.writeText "rosetta-early-init.el" (builtins.readFile "${rosetta-config}/early-init.el");
    })

    (epkgs.trivialBuild {
      pname = "rosetta-init";
      packageRequires = [epkgs.use-package];
      src = pkgs.writeText "rosetta-init.el" (builtins.readFile "${rosetta-config}/init.el");

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
