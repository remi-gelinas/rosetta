{
  pkgs,
  emacs-unstable,
  ...
} @ localFlake: let
  name = "rosetta-emacs";

  emacsPackage =
    if pkgs.stdenv.isDarwin
    then
      import ./darwin {
        pname = name;
        inherit pkgs emacs-unstable;
      }
    else emacs-unstable.packages.emacsGit-nox;

  config = import ./config {
    inherit pkgs;
    inherit (localFlake) config;
  };

  emacsWithPackages = (pkgs.emacsPackagesFor emacsPackage).emacsWithPackages (_: config.packages);
in
  # Ensure required runtime dependencies for Emacs are available. In this case, python and LSP server binaries.
  pkgs.symlinkJoin {
    inherit name;

    meta.mainProgram = emacsWithPackages.name;
    nativeBuildInputs = [pkgs.makeWrapper];

    paths = [
      emacsWithPackages
    ];

    postBuild = ''
      makeWrapper ${pkgs.python311.interpreter} $out/bin/python --unset PYTHONPATH
    '';
  }
