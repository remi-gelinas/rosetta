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

    rosetta-config-org = self'.legacyPackages.builders.tangleOrgDocument {
      src = ./config.org;
    };
  in [
    (epkgs.trivialBuild rec {
      pname = "rosetta-early-init";
      packageRequires = configDependencies;

      src = pkgs.runCommand "${pname}-src" {} ''
        mkdir $out
        cp ${rosetta-config-org}/early-init.el $out/
      '';
    })

    (epkgs.trivialBuild rec {
      pname = "rosetta-init";
      packageRequires = [epkgs.use-package];

      src = pkgs.runCommand "${pname}-src" {} ''
        mkdir $out
        cp ${rosetta-config-org}/init.el $out/
      '';

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
