args: [
  (import ./utils.nix args)
  (import ./default-el.nix args)
  (import ./early-init.nix args)

  (import ./frame.nix args)
  (import ./font.nix args)
  (import ./general.nix args)

  (import ./nord-theme.nix args)
  (import ./nix.nix args)
  (import ./lua.nix args)
  (import ./org.nix args)
  (import ./magit.nix args)
  (import ./envrc.nix args)
  (import ./aggressive-indent.nix args)
]
