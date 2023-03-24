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

      prelude = ''
        ;; Remove all window decoration
        (add-to-list 'default-frame-alist '(undecorated .t))

        ;; Disable startup message.
        (setq inhibit-startup-screen t
              inhibit-startup-echo-area-message (user-login-name))

        ;; Don't blink the cursor.
        (setq blink-cursor-mode nil)

        ;; Accept 'y' and 'n' rather than 'yes' and 'no'.
        (defalias 'yes-or-no-p 'y-or-n-p)

        ;; Always show line and column number in the mode line.
        (line-number-mode)
        (column-number-mode)

        ;; Ensure spaces instead of tabs, 2 spaces per indentation
        (setq-default indent-tabs-mode nil
                        tab-width 2
                        c-basic-offset 2)
        
        ;; Remove trailing whitespace
        (setq-default show-trailing-whitespace t)

        ;; Prefer UTF-8
        (prefer-coding-system 'utf-8)

        ;; Disable bell
        (setq visible-bell t)
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
