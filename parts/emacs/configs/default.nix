localFlake: [
  (import ./utils.nix localFlake)
  (import ./default-el.nix localFlake)

  (import ./frame.nix localFlake)
  (import ./font.nix localFlake)

  (import ./nord-theme.nix localFlake)
  (import ./nix.nix localFlake)
  (import ./elisp.nix localFlake)
  (import ./org.nix localFlake)
  (import ./envrc.nix localFlake)
  (import ./aggressive-indent.nix localFlake)
]
