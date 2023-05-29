{
  pkgs,
  lib,
  ...
}: {
  name ? "org-document",
  pname ? "",
  src,
  emacs ? pkgs.emacs,
  ...
} @ args: let
  inherit (pkgs) stdenvNoCC;
  substituteTemplateVars = (args ? templateVars) && (args.templateVars != {});
in
  lib.makeOverridable stdenvNoCC.mkDerivation {
    inherit name pname src;
    buildInputs = [emacs];

    unpackPhase = ''
      runHook preUnpack

      if [[ ! (-f $src) ]]; then
        echo "error: source must be a single file"
        exit 1
      fi

      documentName=$(stripHash $src)
      buildDir="dist"

      install -d $buildDir
      cp $src "$buildDir/$documentName"

      runHook postUnpack
    '';

    preBuild = ''
      ${
        lib.optionalString substituteTemplateVars
        (
          "substitute $buildDir/$documentName $buildDir/$documentName \\"
          + (
            lib.pipe args.templateVars [
              (lib.mapAttrsToList (name: value: "--subst-var-by \"${name}\" \"${value}\""))
              (lib.concatStringsSep "\\\n")
            ]
          )
        )
      }
    '';

    buildPhase = ''
      runHook preBuild

      emacs -Q --batch \
        --eval "(require 'org)" \
        --eval "(org-babel-tangle-file \"$buildDir/$documentName\")"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      rm $buildDir/$documentName

      install -d $out
      install $buildDir/* $out

      runHook postInstall
    '';
  }
