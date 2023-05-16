{pkgs, ...} @ args: {pname, ...}: let
  patches = import ./patches.nix args;
in
  (pkgs.emacsPgtk.override {withX = false;}).overrideAttrs (final: prev: {
    inherit pname;
    name = "${final.pname}-${prev.version}";
    patches = (prev.patches or []) ++ patches;
    configureFlags =
      (prev.configureFlags or [])
      ++ [
        "--with-poll"
      ];
    platforms = pkgs.lib.platforms.darwin;
  })
