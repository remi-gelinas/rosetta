{pkgs, ...}: let
  # emacs-plus repo revision
  rev = "e98ed093f5f007dc3bb2a9bcba3087286feda27f";

  patches = [
    # fix-window-role.patch
    (pkgs.fetchpatch
      {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/${rev}/patches/emacs-28/fix-window-role.patch";
        sha256 = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
      })

    # no-frame-refocus-cocoa.patch
    (pkgs.fetchpatch
      {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/${rev}/patches/emacs-28/no-frame-refocus-cocoa.patch";
        sha256 = "sha256-QLGplGoRpM4qgrIAJIbVJJsa4xj34axwT3LiWt++j/c=";
      })

    # poll.patch
    (pkgs.fetchpatch
      {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/${rev}/patches/emacs-29/poll.patch";
        sha256 = "sha256-jN9MlD8/ZrnLuP2/HUXXEVVd6A+aRZNYFdZF8ReJGfY=";
      })

    # system-appearance.patch
    (pkgs.fetchpatch
      {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/${rev}/patches/emacs-28/system-appearance.patch";
        sha256 = "sha256-oM6fXdXCWVcBnNrzXmF0ZMdp8j0pzkLE66WteeCutv8=";
      })
  ];
in
  pkgs.emacsGit.overrideAttrs (prev: {
    patches = patches ++ prev.patches;
    buildInputs = with pkgs;
      prev.buildInputs
      ++ [
        harfbuzz.dev
        cairo
      ];

    configureFlags =
      prev.configureFlags
      ++ [
        "--with-harfbuzz"
        "--with-cairo"
      ];
  })
