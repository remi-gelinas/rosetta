{
  localFlake,
  mkEmacsPackage,
  ...
}:
mkEmacsPackage "nix-ts-mode" ({system, ...}: let
  nixpkgs-master = import localFlake.inputs.nixpkgs-master {
    inherit system;

    config = localFlake.config.nixpkgsConfig;
    overlays = [localFlake.inputs.emacs-unstable.overlays.default];
  };
in {
  requiresPackages = [
    (nixpkgs-master.emacsPackages.manualPackages.treesit-grammars.with-grammars
      (grammars: [
        grammars.tree-sitter-nix
      ]))
  ];
})
