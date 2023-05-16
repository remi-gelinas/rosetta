{pkgs, ...} @ args: let
  pname = "rosetta-emacs";

  emacsPackage =
    if pkgs.stdenv.isDarwin
    then import ./darwin args {inherit pname;}
    else pkgs.emacsGit;

  config = import ./config args;
in
  (pkgs.emacsPackagesFor emacsPackage).emacsWithPackages (_: config.packages)
