localFlake: [
  (import ./utils.nix localFlake)
  (import ./default-el.nix localFlake)

  (import ./frame.nix localFlake)
  (import ./font.nix localFlake)

  (import ./nord-theme.nix localFlake)
  (import ./nix.nix localFlake)
]
