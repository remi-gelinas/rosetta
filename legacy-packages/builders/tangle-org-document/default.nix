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
} @ args:
stdenvNoCC.mkDerivation (args
  // {
    buildInputs = [emacs perl];

    unpackPhase = builtins.readFile ./phases/unpack.sh;
    buildPhase = builtins.readFile ./phases/build.sh;
    installPhase = builtins.readFile ./phases/install.sh;
  })
