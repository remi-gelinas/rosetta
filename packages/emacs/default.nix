{
  pkgs,
  self',
  ...
} @ args: let
  name = "rosetta-emacs";

  emacsPackage =
    if pkgs.stdenv.isDarwin
    then import ./darwin args {pname = name;}
    else pkgs.emacsGit;

  config = import ./config args;

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
