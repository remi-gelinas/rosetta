{
  stdenvNoCC,
  emacs,
  perl,
  ...
}: {
  name ? "org-document",
  pname ? "",
  ...
} @ args:
stdenvNoCC.mkDerivation (args
  // {
    inherit name pname;
    buildInputs = [emacs perl];

    unpackPhase = builtins.readFile ./phases/unpack.sh;
    buildPhase = builtins.readFile ./phases/build.sh;
    installPhase = builtins.readFile ./phases/install.sh;
  })
