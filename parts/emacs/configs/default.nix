localFlake: [
  (import ./utils.nix localFlake)
  (import ./default-el.nix localFlake)
  (import ./early-init.nix localFlake)

  (import ./frame.nix localFlake)
  (import ./font.nix localFlake)
  (import ./general.nix localFlake)

  (import ./nord-theme.nix localFlake)
  (import ./nix.nix localFlake)
  (import ./lua.nix localFlake)
  (import ./org.nix localFlake)
  (import ./magit.nix localFlake)
  (import ./envrc.nix localFlake)
  (import ./aggressive-indent.nix localFlake)
]
