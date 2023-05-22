{
  lib,
  stdenvNoCC,
  emacs,
  perl,
  ...
}: {
  name ? "org-document",
  pname ? "",
  src,
  ...
} @ args: let
  substituteTemplateVars = (args ? templateVars) && (args.templateVars != {});
in
  stdenvNoCC.mkDerivation {
    inherit name pname src;
    buildInputs = [emacs perl];

    unpackPhase = ''
      if [[ ! (-f $src) ]]; then
        echo "error: source must be a single file"
        exit 1
      fi

      documentName=$(echo $src | perl -wne '/.*-(.*)/i and print $1')
      buildDir="dist"

      install -d $buildDir
      cp $src "$buildDir/$documentName"
    '';

    preBuild = ''
      ${
        if substituteTemplateVars
        then
          (let
            inherit (lib.attrsets) mapAttrsToList;
            inherit (lib.strings) concatStringsSep;
          in
            "substitute $buildDir/$documentName $buildDir/$documentName \\" + concatStringsSep "\\\n" (mapAttrsToList (name: value: "--subst-var-by \"${name}\" \"${value}\"") args.templateVars))
        else ""
      }
    '';

    buildPhase = ''
      runHook preBuild

      emacs -Q --batch \
        --eval "(require 'org)" \
        --eval "(org-babel-tangle-file \"$buildDir/$documentName\")"
    '';

    installPhase = ''
      rm $buildDir/$documentName

      install -d $out
      install $buildDir/* $out
    '';
  }
