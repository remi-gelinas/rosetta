(setq package-quickstart t
    package-quickstart-file "rosetta-package-quickstart.el")

(advice-add 'load-file :override
    (lambda (file) (load (expand-file-name file) nil t t)))


;; Remove all window decoration
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . nil) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(undecorated . t))

(add-to-list 'default-frame-alist '(font . "PragmataPro Mono Liga-20" ))
(set-face-attribute 'default t :font "PragmataPro Mono Liga-20" )

;; Avoid expensive frame resizing. Inspired by Doom Emacs.
(setq frame-inhibit-implied-resize t)

(provide 'rosetta-early-init)