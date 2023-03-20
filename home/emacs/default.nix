{ config, lib, pkgs, nurNoPkgs, ... }:

let
  CONFIG_DIR = "${config.xdg.configHome}/emacs";
in
{
  imports = [
    nurNoPkgs.repos.rycee.hmModules.emacs-init
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.custom.emacs;

    init = {
      enable = true;

      packageQuickstart = false;
      recommendedGcSettings = true;
      usePackageVerbose = false;

      earlyInit = ''
        (push '(menu-bar-lines . 0) default-frame-alist)
        (push '(tool-bar-lines . nil) default-frame-alist)
        (push '(vertical-scroll-bars . nil) default-frame-alist)

        (set-face-attribute 'default
                            nil
                            :height 80
                            :family "PragmataPro Mono Liga")
      '';

      usePackage = {
        # Theme
        nord-theme = {
          enable = true;
          config = ''
            (load-theme 'nord t)
          '';
        };

        # LSP
        lsp-mode = {
          enable = true;
          init = "";
        };

        ## Nix
        lsp-nix = {
          enable = true;
          after = [ "lsp-mode" ];

          extraConfig = ''
            :custom
            (lsp-nix-nil-formatter ["nixpkgs-fmt"])
          '';
        };

        nix-mode = {
          enable = true;
          hook = [ "(nix-mode . lsp-deferred)" ];
        };

        # Misc
        org = { enable = true; };

        vertico = { enable = true; };

        consult = { enable = true; };

        orderless = { enable = true; };

        embark = { enable = true; };
        embark-consult = { enable = true; };

        marginalia = { enable = true; };

        corfu = { enable = true; };
      };
    };
  };
}
