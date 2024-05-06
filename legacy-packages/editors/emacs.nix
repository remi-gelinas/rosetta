{ emacs-unstable
, homebrew-emacs-plus
, system
, stdenv
, lib
,
}:
let
  # Darwin resources
  homebrewEmacsPlus = homebrew-emacs-plus.src;

  darwinIcon = "${homebrewEmacsPlus}/icons/modern-mzaplotnik.icns";
  darwinPatches = [
    "${homebrewEmacsPlus}/patches/emacs-28/fix-window-role.patch"
    "${homebrewEmacsPlus}/patches/emacs-30/round-undecorated-frame.patch"
    "${homebrewEmacsPlus}/patches/emacs-29/poll.patch"
    "${homebrewEmacsPlus}/patches/emacs-28/system-appearance.patch"
  ];

  # Emacs
  emacsPackage = emacs-unstable.packages.${system}.emacs-git.overrideAttrs (prev: rec {
    passthru =
      prev.passthru
      // {
        treeSitter = true;
      };

    patches =
      (prev.patches or [ ])
      ++ lib.optional stdenv.isDarwin darwinPatches;
    configureFlags =
      (prev.configureFlags or [ ])
      ++ lib.optional stdenv.isDarwin "--with-poll";

    postInstall =
      (prev.postInstall or "")
      + (lib.optionalString stdenv.isDarwin ''
        # Replace the original MacOS bundle icon
        rm $out/Applications/Emacs.app/Contents/Resources/Emacs.icns
        ln -s  ${darwinIcon} $out/Applications/Emacs.app/Contents/Resources/Emacs.icns
      '');
  });
in
emacsPackage
