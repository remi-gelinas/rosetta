{self, ...}: {pkgs, ...}: let
  emacs =
    if pkgs.stdenv.isDarwin
    then self.packages.${pkgs.system}.emacs-plus-git
    else pkgs.emacsGit.override {nativeComp = true;};
in {
  home.sessionVariables = {
    EDITOR = "${emacs}/bin/emacs -nw";
  };

  programs.emacs = {
    enable = false;
    package = emacs;

    init = {
      enable = true;

      packageQuickstart = false;
      recommendedGcSettings = true;
      usePackageVerbose = false;

      earlyInit = ''
        ;; Remove all window decoration
        (push '(menu-bar-lines . 0) default-frame-alist)
        (push '(tool-bar-lines . nil) default-frame-alist)
        (push '(vertical-scroll-bars . nil) default-frame-alist)
        (add-to-list 'default-frame-alist '(fullscreen . maximized))
        (add-to-list 'default-frame-alist '(undecorated . t))

        (add-to-list 'default-frame-alist '(font . "PragmataPro Mono Liga-20" ))
        (set-face-attribute 'default t :font "PragmataPro Mono Liga-20" )
      '';

      prelude = ''
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

        ## Nix
        nix-mode = {
          enable = true;

          config = ''
            ;; (add-to-list 'eglot-server-programs '((nix-mode) . ("${pkgs.nil}/bin/nil")))
          '';
        };

        # Misc
        org = {enable = true;};

        vertico = {enable = true;};

        consult = {enable = true;};

        orderless = {enable = true;};

        embark = {enable = true;};
        embark-consult = {enable = true;};

        marginalia = {enable = true;};

        corfu = {enable = true;};
      };
    };
  };
}
