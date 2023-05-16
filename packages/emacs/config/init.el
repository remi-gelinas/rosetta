(eval-when-compile
        (require 'use-package)
        ;; To help fixing issues during startup.
        (setq use-package-verbose nil))

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

;; Set nord theme
(use-package nord-theme 
  :config
  (load-theme 'nord t)
  )

(provide 'rosetta-init)