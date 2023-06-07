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

    preBuild = let
      substArgs = with lib;
        pipe args.templateVars [
          (mapAttrsToList (name: value: "--subst-var-by \"${name}\" \"${value}\""))
          (concatStringsSep " ")
        ];
    in
      lib.optionalString substituteTemplateVars "substitute $buildDir/$documentName $buildDir/$documentName ${substArgs}";

    buildPhase = ''
      runHook preBuild

      emacs -Q --batch \
        --file $buildDir/$documentName \
        --funcall org-babel-tangle

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
