# Configuration strategy inspired by Rycee's HM module at https://git.sr.ht/~rycee/nur-expressions/tree/master/item/hm-modules/emacs-init.nix
{
  pkgs,
  self',
  ...
}: rec {
  packages = let
    epkgs = pkgs.emacsPackages;

    configDependencies = with epkgs; [
      nord-theme
      elisp-autofmt
    ];

    rosetta-config = self'.legacyPackages.builders.tangleOrgDocument {
      name = "rosetta-config-org-src";
      src = ./config.org;
    };
  in [
    (epkgs.trivialBuild rec {
      pname = "rosetta-early-init";
      src = pkgs.runCommand "${pname}-src" {} ''
        mkdir $out
        cp ${rosetta-config}/early-init.el $out/
      '';
      packageRequires = configDependencies;
    })

    (epkgs.trivialBuild rec {
      pname = "rosetta-init";
      src = pkgs.runCommand "${pname}-src" {} ''
        mkdir $out
        cp ${rosetta-config}/init.el $out/
      '';
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
