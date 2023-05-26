{
  pname,
  pkgs,
  emacs-unstable,
}: let
  patches = import ./patches.nix {inherit pkgs;};
in
  emacs-unstable.packages.emacsGit-nox.overrideAttrs (final: prev: {
    inherit pname;
    name = "${final.pname}-${prev.version}";
    patches = (prev.patches or []) ++ patches;
    configureFlags =
      (prev.configureFlags or [])
      ++ [
        "--with-poll"
      ];
  })
