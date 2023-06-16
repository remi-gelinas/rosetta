localFlake: {
  perSystem = {system, ...}: let
    name = "nix-config";
  in {
    config.emacs.configPackages.${name} = {
      inherit name;
      requiresBinariesFrom = pkgs: [
        pkgs.nil
      ];

      requiresPackages = let
        configPackages = localFlake.withSystem system ({config, ...}: config.emacs.configPackages);
      in
        epkgs: [
          configPackages.rosetta-utils.finalPackage
          epkgs.nix-mode
        ];

      code = ''
        (require 'nix-mode)

        ;; LSP config
        (unless (version< emacs-version "29.0")
          (progn
            (require 'eglot)
            (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
            (add-hook 'nix-mode-hook 'eglot-ensure)))
      '';
    };
  };
}
