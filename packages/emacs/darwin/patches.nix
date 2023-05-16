{pkgs, ...}: let
  # Patches pull from https://github.com/d12frosted/homebrew-emacs-plus
  rev = "c28150477651c03b55048f9f3edc82caec861a73";
in [
  (pkgs.fetchpatch
    {
      url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/${rev}/patches/emacs-28/fix-window-role.patch";
      sha256 = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
    })

  (pkgs.fetchpatch
    {
      url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/${rev}/patches/emacs-30/round-undecorated-frame.patch";
      sha256 = "sha256-uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
    })

  (pkgs.fetchpatch
    {
      url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/${rev}/patches/emacs-28/no-frame-refocus-cocoa.patch";
      sha256 = "sha256-QLGplGoRpM4qgrIAJIbVJJsa4xj34axwT3LiWt++j/c=";
    })

  (pkgs.fetchpatch
    {
      url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/${rev}/patches/emacs-29/poll.patch";
      sha256 = "sha256-jN9MlD8/ZrnLuP2/HUXXEVVd6A+aRZNYFdZF8ReJGfY=";
    })

  (pkgs.fetchpatch
    {
      url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/${rev}/patches/emacs-28/system-appearance.patch";
      sha256 = "sha256-oM6fXdXCWVcBnNrzXmF0ZMdp8j0pzkLE66WteeCutv8=";
    })
]
