{
  config,
  emacs-unstable,
}: {pkgs, ...}: let
  # Darwin resources
  homebrewEmacsPlus = pkgs.fetchFromGitHub {
    owner = "d12frosted";
    repo = "homebrew-emacs-plus";
    rev = "b926ff102067d3864ff4cb8060962ec4d46510ef";
    hash = "sha256-WAGKPYOphID1HJHk/pyDxv/fvWUNqUjL6KL/7eyyC0A=";
  };

  darwinIcon = "${homebrewEmacsPlus}/icons/modern-mzaplotnik.icns";
  darwinPatches = [
    "${homebrewEmacsPlus}/patches/emacs-28/fix-window-role.patch"
    "${homebrewEmacsPlus}/patches/emacs-30/round-undecorated-frame.patch"
    "${homebrewEmacsPlus}/patches/emacs-28/no-frame-refocus-cocoa.patch"
    "${homebrewEmacsPlus}/patches/emacs-29/poll.patch"
    "${homebrewEmacsPlus}/patches/emacs-28/system-appearance.patch"
  ];

  # Emacs
  emacsPackage = with pkgs; let
    withTreeSitter = emacs-unstable.packages.${pkgs.system}.emacs-git.override {withTreeSitter = true;};
  in
    withTreeSitter.overrideAttrs (prev: rec {
      patches =
        (prev.patches or [])
        ++ lib.optional stdenv.isDarwin darwinPatches;
      configureFlags =
        (prev.configureFlags or [])
        ++ lib.optional stdenv.isDarwin "--with-poll";

      postInstall = with pkgs;
        (prev.postInstall or "")
        + (lib.optionalString stdenv.isDarwin ''
          # Replace the original MacOS bundle icon
          rm $out/Applications/Emacs.app/Contents/Resources/Emacs.icns
          ln -s  ${darwinIcon} $out/Applications/Emacs.app/Contents/Resources/Emacs.icns
        '');
    });
in
  emacs-unstable.lib.${pkgs.system}.emacsWithPackagesFromUsePackage {
    inherit config;

    defaultInitFile = true;
    alwaysEnsure = false;
    alwaysTangle = false;

    package = emacsPackage;
  }
